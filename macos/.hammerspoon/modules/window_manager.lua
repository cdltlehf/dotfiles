local checkMods = require('hs.eventtap').checkKeyboardModifiers
local timer = require('hs.timer')
local leader = { "ctrl", "cmd" }

local MODS_INTERVAL = 0.05
local PADDING = 5
local DURATION = 0
local DELAY = 1.5
local HIDE_BOXES_DELAY = 0.2
local SHOW_BOX_DELAY = 0.5

-- FIXME: add some kind of set_leader to set leader from outside

local function modsPressed()
  local mods = checkMods(true)._raw
  return mods > 0
end

local function getFrameWithRatio(window,x,y,w,h,padding)
  local padding = padding or 0

  local window_frame = window:frame()
  local screen_frame = window:screen():frame()

  inner_screen_frame = {
    x = screen_frame.x+padding/2,
    y = screen_frame.y+padding/2,
    w = screen_frame.w - padding,
    h = screen_frame.h - padding
  }

  if x ~= nil then
    window_frame.x = inner_screen_frame.x + x*inner_screen_frame.w + padding
  end
  if y ~= nil then
    window_frame.y = inner_screen_frame.y + y*inner_screen_frame.h + padding
  end

  if w ~= nil then
    window_frame.w = w * (inner_screen_frame.w-padding) - padding
  end
  if h ~= nil then
    window_frame.h = h * (inner_screen_frame.h-padding) - padding
  end

  return window_frame
end

local boxes = {}

local function showBox(f, text, delay)
  local text = text or ''
  local delay = delay or 0
  padding = padding or 0
  local f = {
    x = f.x + padding,
    y = f.y + padding,
    w = f.w - padding*2,
    h = f.h - padding*2,
  }
  canvas = hs.canvas.new(f):appendElements(
    {
      type = "rectangle",
      fillColor = { black = 0.3, alpha = 0.5 },
      action = "fill",
      roundedRectRadii = { xRadius = 10, yRadius = 10 },
    },
    {
      type = "text",
      text = string.upper(text),
      frame = { x = "0%", y = f.h / 2 - 100, h = "100%", w = "100%" },
      textAlignment = "center",
      textSize = 150,
    }
  ):level('floating')
  canvas:show(0.2)
  boxes[#boxes+1] = canvas
end

local function hideBoxes(delay)
  local delay = delay or 0
  for i = 1, #boxes do
    boxes[i]:hide(delay)
    boxes[i] = nil
  end
end

local function modsPressed()
  return checkMods(true)._raw > 0
end

local function setDefaultWindowManagerKeyMap()

  local window = nil
  local state = nil

  local keymap = {}
  keymap[''] = { { 0.25, 0.25, 0.5, 0.5 } }

  keymap['h'] = { -- Left
    { 0, 0, 0.5, 1 },
    ['k']='hk', ['j']='hj', ['l']='l'
  }
  keymap['j'] = { -- Down
    { 0, 0.5, 1, 0.5 },
    ['k']='kk', ['h']='hj', ['l']='lj'
  }
  keymap['k'] = { -- Full
    { 0, 0, 1, 1 },
    ['k']='kk', ['j']='j'
  }
  keymap['l'] = { -- Right
    { 0.5, 0, 0.5, 1 },
    ['k']='lk', ['j']='lj', ['h']='h'
  }

  keymap['hj'] = { -- Left-down
    { 0, 0.5, 0.5, 0.5 },
    ['k']='hk', ['l']='lj',
  }
  keymap['hk'] = { -- Left-up
    { 0, 0, 0.5, 0.5 },
    ['j']='hj', ['l']='lk',
  }
  keymap['lj'] = { -- Right-down
    { 0.5, 0.5, 0.5, 0.5 },
    ['h']='hj', ['k']='lk',
  }
  keymap['lk'] = { -- Right-up
    { 0.5, 0, 0.5, 0.5 },
    ['h']='hk', ['j']='lj',
  }
  keymap['kk'] = { -- Up
    { 0, 0, 1, 0.5 },
    ['h']='hk', ['l']='lk', ['j']='j'
  }

  local delay = DELAY

  local draw_timer = timer.delayed.new(
    0,
    function()
      hideBoxes(HIDE_BOXES_DELAY)
      if not window then return end
      delay = 0

      for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
        local next_state = keymap[state or ''][key]
        if next_state then
          local ratio = keymap[next_state][1]
          local f = getFrameWithRatio(
            window, ratio[1], ratio[2], ratio[3], ratio[4], PADDING)
          showBox(f, key, SHOW_BOX_DELAY)
        end
      end
    end)

  local modifier_timer = timer.waitWhile(
    modsPressed,
    function()
      window = nil
      state = nil

      hideBoxes(HIDE_BOXES_DELAY)
    end,
    MODS_INTERVAL):stop()

  for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
    hs.hotkey.bind(leader, key, function()
      if not state then delay = 0.5 end

      -- Start modifier timer which checks whether modifier released
      modifier_timer:start()

      -- If window is not specified, find window
      window = window or hs.window.focusedWindow()

      -- Update state
      -- If the next state is not explicitly defined, key is the next state
      state = keymap[state or ''][key] or key

      -- Update window based on the state
      local ratio = keymap[state][1]
      local f = getFrameWithRatio(
        window, ratio[1], ratio[2], ratio[3], ratio[4], PADDING)

      draw_timer:start(delay)

      window:setFrame(f, DURATION)
    end)
  end
end

setDefaultWindowManagerKeyMap()

hs.hotkey.bind({ "shift", table.unpack(leader) }, "l", function()
  hs.caffeinate.lockScreen()
end)

-- vim:ts=2:sts=2:sw=2:et:sta:fdm=manual:fdl=0
