local eventtap = require("hs.eventtap")
local alert = require("hs.alert")
local keycodes = require("hs.keycodes")
local hotkey = require("hs.hotkey")

local KeyboardManager = {}
KeyboardManager.__index = KeyboardManager

local webview = nil

local function getWebview()
  if not webview then
    local focused = hs.window.focusedWindow()
    local screen_frame = focused and focused:screen():frame() or hs.screen.mainScreen():frame()
    local w, h = 800, 200
    local x = screen_frame.w / 2 - w / 2
    local y = screen_frame.h - h
    webview = hs.webview.new({ x = x, y = y, w = w, h = h })
    local url = "file://" .. hs.configdir .. "/modules/korean_3set/index.html"
    webview:transparent(true)
    webview:url(url)
    webview:bringToFront(false)
  end
  return webview
end

function KeyboardManager.new(default_source_id)
  local self = setmetatable({}, KeyboardManager)

  self._escape_callback = function()
    keycodes.currentSourceID(default_source_id)
    keycodes.currentSourceID("com.apple.keylayout.ABC")
    self.escape_bind:disable()
    eventtap.keyStroke(eventtap.event.types.keyStroke, "escape", 0)
    self.escape_bind:enable()
  end
  self.escape_bind = hotkey.new({}, "escape", self._escape_callback)

  self.input_source_changed_callback = function()
    local current_source_id = keycodes.currentSourceID()
    if current_source_id == self.last_alerted_source_id then
      return
    end

    if self.last_alert_uuid ~= nil then
      alert.closeSpecific(self.last_alert_uuid)
    end
    self.last_alerted_source_id = keycodes.currentSourceID()

    local label = self.last_alerted_source_id:match(".%w+$"):sub(2)
    self.last_alert_uuid = alert.show(label, 0.2)
    print(self.last_alerted_source_id)

    if label == "390Sebulshik" then
      getWebview():show()
    elseif webview then
      webview:hide()
    end
  end

  self.last_alerted_source_id = nil

  return self
end

function KeyboardManager:start()
  self.escape_bind:enable()
end

function KeyboardManager:stop()
  self.escape_bind:disable()
end

return KeyboardManager
