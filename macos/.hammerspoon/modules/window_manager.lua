local checkMods = require'hs.eventtap'.checkKeyboardModifiers
local timer = require'hs.timer'
local leader = {"ctrl","cmd"}

local MODS_INTERVAL=0.05
local PADDING = 5
local DURATION = 0

-- FIXME: add some kind of set_leader to set leader from outside

local function modsPressed()
  local mods = checkMods(true)._raw
  return mods > 0
end

local function setWindowRatio(window,x,y,w,h,padding,duration)
  padding = padding or 0; duration = duration or 0

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

  window:setFrame(window_frame, duration)
end

local function modsPressed()
  return checkMods(true)._raw > 0
end

local state = nil
local function resetState() state = nil end

local function setDefaultWindowManagerKeyMap()

  hs.hotkey.bind(leader, 'h', function()
    window = hs.window.focusedWindow()

    if not state then
      setWindowRatio(window, 0, 0, 0.5, 1, PADDING, DURATION)
      state = 'h'
    elseif state == 'h' then
      setWindowRatio(window, 0, 0, 0.375, 1, PADDING, DURATION)
      state = 'hh'
    elseif state == 'l' then
      setWindowRatio(window, 0.375, 0, 0.625, 1, PADDING, DURATION)
      state = 'lh'
    end

    timer.waitWhile(modsPressed, resetState, MODS_INTERVAL)
  end)

  hs.hotkey.bind(leader, 'l', function()
    window = hs.window.focusedWindow()

    if not state then
      setWindowRatio(window, 0.5, 0, 0.5, 1, PADDING, DURATION)
      state = 'l'
    elseif state == 'h' then
      setWindowRatio(window, 0, 0, 0.625, 1, PADDING, DURATION)
      state = 'hl'
    elseif state == 'l' then
      setWindowRatio(window, 0.625, 0, 0.375, 1, PADDING, DURATION)
      state = 'll'
    end

    timer.waitWhile(modsPressed, resetState, MODS_INTERVAL)
  end)

  hs.hotkey.bind(leader, "k", function()
    window = hs.window.focusedWindow()

    if not state then
      setWindowRatio(window, 0, 0, 1, 1, PADDING, DURATION)
      state = 'k'
    elseif state == 'k' then
      setWindowRatio(window, 0, 0, 1, 0.5, PADDING, DURATION)
      state = 'kk'
    else
    end

    timer.waitWhile(modsPressed, resetState, MODS_INTERVAL)
  end)

  hs.hotkey.bind(leader, "j", function()
    window = hs.window.focusedWindow()

    if not state or
      state == 'k' then
      setWindowRatio(window, 0, 0.5, 1, 0.5, PADDING, DURATION)
      state = 'j'
    else
    end

    timer.waitWhile(modsPressed, resetState, MODS_INTERVAL)
  end)
end

setDefaultWindowManagerKeyMap()

hs.hotkey.bind({ "shift", table.unpack(leader) }, "l", function()
  hs.caffeinate.lockScreen()
end)

-- vim:ts=2:sts=2:sw=2:et:sta:fdm=manual:fdl=0
