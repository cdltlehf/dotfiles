local checkMods = require('hs.eventtap').checkKeyboardModifiers

local window = require('hs.window')
local timer = require('hs.timer')
local hotkey = require('hs.hotkey')
local spaces = require('hs.spaces')
local canvas = require('hs.canvas')
local eventtap = require('hs.eventtap')

local MODS_INTERVAL = 0.05
local PADDING = 5
local DURATION = 0

local INDICATOR_DELAY = 1
local HIDE_BOXES_DELAY = 0.2
local SHOW_BOX_DELAY = 0.2

local MISSION_CONTROL_DELAY = 0.3 -- Mission Control animation delay
local DEFAULT_LEADER = { "ctrl", "cmd" }

local function modsPressed()
  local mods = checkMods(true)._raw
  return mods > 0
end

local function getFrameWithRatio(screen, x, y, w, h, padding)
  local padding = padding or 0

  local screen_frame = screen:frame()

  local inner_screen_frame = {
    x = screen_frame.x + padding/2,
    y = screen_frame.y + padding/2,
    w = screen_frame.w - padding,
    h = screen_frame.h - padding
  }

  local frame = {
    x = inner_screen_frame.x + x*inner_screen_frame.w + padding,
    y = inner_screen_frame.y + y*inner_screen_frame.h + padding,
    w = w * (inner_screen_frame.w-padding) - padding,
    h = h * (inner_screen_frame.h-padding) - padding
  }

  return frame
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

local WindowManager = { keymap = {} }
WindowManager.keymap[''] = { -- Default
  { 0.25, 0.25, 0.5, 0.5 },
  ['h']='h', ['l']='l'
}
WindowManager.keymap['h'] = { -- Left
  { 0, 0, 0.5, 1 },
  ['k']='hk', ['j']='hj', ['l']='l'
}

WindowManager.keymap['j'] = { -- Down
  { 0, 0.5, 1, 0.5 },
  ['k']='kk', ['h']='hj', ['l']='lj'
}
WindowManager.keymap['k'] = { -- Full
  { 0, 0, 1, 1 },
  ['k']='kk', ['j']='j'
}
WindowManager.keymap['l'] = { -- Right
  { 0.5, 0, 0.5, 1 },
  ['k']='lk', ['j']='lj', ['h']='h'
}

WindowManager.keymap['hj'] = { -- Left-down
  { 0, 0.5, 0.5, 0.5 },
  ['k']='hk', ['l']='lj',
}
WindowManager.keymap['hk'] = { -- Left-up
  { 0, 0, 0.5, 0.5 },
  ['j']='hj', ['l']='lk',
}
WindowManager.keymap['lj'] = { -- Right-down
  { 0.5, 0.5, 0.5, 0.5 },
  ['h']='hj', ['k']='lk',
}
WindowManager.keymap['lk'] = { -- Right-up
  { 0.5, 0, 0.5, 0.5 },
  ['h']='hk', ['j']='lj',
}
WindowManager.keymap['kk'] = { -- Up
  { 0, 0, 1, 0.5 },
  ['h']='hk', ['l']='lk', ['j']='j'
}
WindowManager.__index = WindowManager

function WindowManager.new(leader)
  local self = setmetatable({}, WindowManager)

  self.leader = leader or DEFAULT_LEADER
  self.padding = PADDING

  self.target_window = nil
  self.state = nil
  self.show_indicator = false
  self.boxes = {}

  self.dragging_eventtap = eventtap.new({
    eventtap.event.types.leftMouseDragged,
    eventtap.event.types.leftMouseDown }, function(event)
      local original_frame = self.target_window:frame()
      local delta_x = event:getProperty(
        eventtap.event.properties.mouseEventDeltaX)
      local delta_y = event:getProperty(
        eventtap.event.properties.mouseEventDeltaY)
      local new_frame = {
        x = original_frame.x + delta_x,
        y = original_frame.y + delta_y,
        w = original_frame.w,
        h = original_frame.h
      }
      self.target_window:setFrame(new_frame, 0)
      return true, {}
    end)

  self.activate_eventtap = eventtap.new(
    { eventtap.event.types.flagsChanged }, function(event)
      local which_flags = event:getFlags()
      local leader_pressed = true
      for _, flag in ipairs(self.leader) do
        if not which_flags[flag] then leader_pressed = false end
      end
      if leader_pressed then self:activate()
      else self:deactivate() end
    end)

  self.draw_timer = timer.delayed.new(INDICATOR_DELAY, function()
    self.show_indicator = true
    self:hideBoxes(HIDE_BOXES_DELAY)
    if not self.target_window then return end

    local focused_space = spaces.focusedSpace()
    if spaces.windowSpaces(self.target_window)[1] ~= focused_space then
      local f = getFrameWithRatio(
        self.target_window:screen(), 0, 0, 1, 1, self.padding)
      self:showBox(f, "No Available Windows", SHOW_BOX_DELAY, 30)
      return
    end

    for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
      local next_state = WindowManager.keymap[self.state or ''][key]
      if next_state then
        local ratio = WindowManager.keymap[next_state][1]
        local f = getFrameWithRatio(
          self.target_window:screen(),
          ratio[1], ratio[2], ratio[3], ratio[4],
          self.padding)
        self:showBox(f, string.upper(key), SHOW_BOX_DELAY)
      end
    end
  end)

  self:_initialize_modal(self.leader)

  return self
end

function WindowManager:_initialize_modal(leader)
  self.modal = hotkey.modal.new()
  for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
    self.modal:bind(leader, key, function()
      self:hideBoxes(HIDE_BOXES_DELAY)
      if self.show_indicator then self.draw_timer:start(0)
      else self.draw_timer:start() end

      -- Do nothing if there is no target window
      if not self.target_window then return end

      -- Do nothing if the target window is not in focused space
      local focused_space = spaces.focusedSpace()
      if spaces.windowSpaces(self.target_window)[1] ~= focused_space then
        return
      end

      -- Update state
      -- If the next state is not explicitly defined, key is the next state
      self.state = WindowManager.keymap[self.state or ''][key] or key

      -- Update window based on the state
      local ratio = WindowManager.keymap[self.state][1]
      local f = getFrameWithRatio(
        self.target_window:screen(),
        ratio[1], ratio[2], ratio[3], ratio[4],
        self.padding)
      self.target_window:setFrame(f, DURATION)
    end)
  end

  self.modal:bind(leader, 'n', function()
    local next_space = getNextSpace()
    if not next_space then return end

    spaces.gotoSpace(next_space)
    self:deactivate()
    timer.doAfter(MISSION_CONTROL_DELAY, function()
      self:activate()
    end)
  end)

  self.modal:bind(leader, 'p', function()
    local prev_space = getPrevSpace()
    if not prev_space then return end

    spaces.gotoSpace(prev_space)
    self:deactivate()
    timer.doAfter(MISSION_CONTROL_DELAY, function()
      self:activate()
    end)
  end)

  self.modal:bind(leader, 'c', function()
    spaces.addSpaceToScreen()
    self:deactivate()
    timer.doAfter(MISSION_CONTROL_DELAY, function()
      self:activate()
      local next_space = getNextSpace()
      if not next_space then return end
      spaces.gotoSpace(next_space)
    end)
  end)

  self.modal:bind(leader, 'x', function()
    local focused_space = spaces.focusedSpace()
    local nextSpace = getNextSpace()
    -- If there is an next space, go to the space
    if next_space then spaces.gotoSpace(next_space)
    else
      -- Else if there is an previous space, go to the space
      local prev_space = getPrevSpace()
      if prev_space then spaces.gotoSpace(prev_space) end
    end
    -- If there is no space to go, the following function fails
    self:deactivate()
    timer.doAfter(MISSION_CONTROL_DELAY, function()
      spaces.removeSpace(focused_space)
      self:activate()
    end)
  end)

  hotkey.bind({ "shift", table.unpack(leader) }, "l", function()
    hs.caffeinate.lockScreen()
  end)
end

function WindowManager:activate()
  self.target_window = window.focusedWindow()
  self.state = nil
  self.show_indicator = false

  self.draw_timer:start()
  self.dragging_eventtap:start()

  self.modal:enter()
end

function WindowManager:deactivate()
  self.show_indicator = false

  self.draw_timer:stop()
  self.dragging_eventtap:stop()

  self:hideBoxes(HIDE_BOXES_DELAY)

  self.modal:exit()
end

function WindowManager:start()
  self.activate_eventtap:start()
  return self
end

function WindowManager:stop()
  self.activate_eventtap:stop()
  return self
end

function WindowManager:showBox(f, text, delay, textSize)
  text = text or ''
  delay = delay or 0
  textSize = textSize or 150

  padding = padding or 0
  local f = {
    x = f.x + padding,
    y = f.y + padding,
    w = f.w - padding*2,
    h = f.h - padding*2,
  }
  self.boxes[#self.boxes+1] = canvas.new(f):appendElements(
    {
      type = "rectangle",
      fillColor = { black = 0.3, alpha = 0.5 },
      action = "fill",
      roundedRectRadii = { xRadius = 10, yRadius = 10 },
    },
    {
      type = "text",
      text = text,
      frame = {
        x = "0%", y = f.h / 2 - textSize * 0.6,
        h = "100%", w = "100%"
      },
      textAlignment = "center",
      textSize = textSize,
    }
  ):level('floating'):show(delay)
end

function WindowManager:hideBoxes(delay)
  local delay = delay or 0
  for i = 1, #self.boxes do
    self.boxes[i]:hide(delay)
    self.boxes[i] = nil
  end
end

return WindowManager

-- vim:ts=2:sts=2:sw=2:et:sta:fdm=manual:fdl=0
