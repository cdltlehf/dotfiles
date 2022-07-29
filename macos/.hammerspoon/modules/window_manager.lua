local checkMods = require('hs.eventtap').checkKeyboardModifiers

local window = require('hs.window')
local timer = require('hs.timer')
local hotkey = require('hs.hotkey')
local spaces = require('hs.spaces')
local canvas = require('hs.canvas')

local leader = { "ctrl", "cmd" }

local MODS_INTERVAL = 0.05
local PADDING = 5
local DURATION = 0

local INDICATOR_DELAY = 1
local HIDE_BOXES_DELAY = 0.2
local SHOW_BOX_DELAY = 0.2

local MISSION_CONTROL_DELAY = 0.3 -- Mission Control animation delay

-- FIXME: add some kind of set_leader to set leader from outside

local function modsPressed()
  local mods = checkMods(true)._raw
  return mods > 0
end

local function getFrameWithRatio(target_window,x,y,w,h,padding)
  local padding = padding or 0

  local window_frame = target_window:frame()
  local screen_frame = target_window:screen():frame()

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
  boxes[#boxes+1] = canvas.new(f):appendElements(
    {
      type = "rectangle",
      fillColor = { black = 0.3, alpha = 0.5 },
      action = "fill",
      roundedRectRadii = { xRadius = 10, yRadius = 10 },
    },
    {
      type = "text",
      text = string.upper(text),
      frame = { x = "0%", y = f.h / 2 - 90, h = "100%", w = "100%" },
      textAlignment = "center",
      textSize = 150,
    }
  ):level('floating'):show(delay)
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

local function getNextSpace()
  local focused_space = spaces.focusedSpace()
  local screen_spaces = spaces.spacesForScreen()
  local previous_space = nil
  for _, space in ipairs(screen_spaces) do
    if previous_space == focused_space then
      return space
    end
    previous_space = space
  end
end

local function getPrevSpace()
  local focused_space = spaces.focusedSpace()
  local screen_spaces = spaces.spacesForScreen()
  local previous_space = nil
  for _, space in ipairs(screen_spaces) do
    if space == focused_space then
      return previous_space
    end
    previous_space = space
  end
end

local function setDefaultWindowManagerKeyMap()

  local target_window = nil
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

  local delay = INDICATOR_DELAY

  local draw_timer = timer.delayed.new(
    0,
    function()
      hideBoxes(HIDE_BOXES_DELAY)
      if not target_window then return end
      delay = 0

      for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
        local next_state = keymap[state or ''][key]
        if next_state then
          local ratio = keymap[next_state][1]
          local f = getFrameWithRatio(
            target_window, ratio[1], ratio[2], ratio[3], ratio[4], PADDING)
          showBox(f, key, SHOW_BOX_DELAY)
        end
      end
    end)

  local modifier_timer = timer.waitWhile(
    modsPressed,
    function()
      target_window = nil
      state = nil

      hideBoxes(HIDE_BOXES_DELAY)
    end,
    MODS_INTERVAL):stop()

  for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
    hotkey.bind(leader, key, function()
      if not state then delay = INDICATOR_DELAY end

      -- Start modifier timer which checks whether modifier released
      modifier_timer:start()

      -- If window is not specified, find window
      target_window = target_window or window.focusedWindow()

      -- Update state
      -- If the next state is not explicitly defined, key is the next state
      state = keymap[state or ''][key] or key

      -- Update window based on the state
      local ratio = keymap[state][1]
      local f = getFrameWithRatio(
        target_window, ratio[1], ratio[2], ratio[3], ratio[4], PADDING)

      draw_timer:start(delay)

      target_window:setFrame(f, DURATION)
    end)
  end
  hotkey.bind(leader, 'n', function()
    local next_space = getNextSpace()
    spaces.gotoSpace(next_space)
  end)
  hotkey.bind(leader, 'p', function()
    local prev_space = getPrevSpace()
    spaces.gotoSpace(prev_space)
  end)
  hotkey.bind(leader, 'c', function()
    spaces.addSpaceToScreen()
    local next_space = getNextSpace()
    timer.doAfter(MISSION_CONTROL_DELAY, function()
      spaces.gotoSpace(next_space)
    end)
  end)
  hotkey.bind(leader, 'x', function()
    local focused_space = spaces.focusedSpace()
    local nextSpace = getNextSpace()
    if next_space then
      -- If there is an next space, go to the space
      spaces.gotoSpace(next_space)
    else
      -- Else if there is an previous space, go to the space
      local prev_space = getPrevSpace()
      if prev_space then
        spaces.gotoSpace(prev_space)
      end
    end
    -- If there is no space to go, the following function fails
    timer.doAfter(MISSION_CONTROL_DELAY, function()
      spaces.removeSpace(focused_space)
    end)
  end)
end

setDefaultWindowManagerKeyMap()

hotkey.bind({ "shift", table.unpack(leader) }, "l", function()
  hs.caffeinate.lockScreen()
end)

-- vim:ts=2:sts=2:sw=2:et:sta:fdm=manual:fdl=0
