local leader = { "ctrl", "cmd" }
-- FIXME: add some kind of set_leader to set leader from outside

local function setFocusedWindowRatio(x, y, w, h, padding, duration)
    if padding == nil then padding = 0 end
    if duration == nil then duration = 0 end

    local window = hs.window.focusedWindow()
    local frame = window:frame()
    local screen_frame = window:screen():frame()

    screen_frame.x = screen_frame.x + padding / 2
    screen_frame.y = screen_frame.y + padding / 2
    screen_frame.w = screen_frame.w - padding
    screen_frame.h = screen_frame.h - padding

    frame.x = screen_frame.x + screen_frame.w * x + padding / 2
    frame.y = screen_frame.y + screen_frame.h * y + padding / 2

    frame.w = screen_frame.w * w - padding
    frame.h = screen_frame.h * h - padding

    window:setFrame(frame, duration)
end

local padding = 5
local duration = 0.02

hs.hotkey.bind(leader, "h", function()
    setFocusedWindowRatio(0, 0, 0.5, 1, padding, duration)
end)
hs.hotkey.bind(leader, "l", function()
    setFocusedWindowRatio(0.5, 0, 0.5, 1, padding, duration)
end)
hs.hotkey.bind(leader, "k", function()
    setFocusedWindowRatio(0, 0, 1, 1, padding, duration)
end)
hs.hotkey.bind(leader, "j", function()
    setFocusedWindowRatio(0.25, 0.25, 0.5, 0.5, padding, duration)
end)
hs.hotkey.bind({ "shift", table.unpack(leader) }, "l", function()
  hs.caffeinate.lockScreen()
end)
