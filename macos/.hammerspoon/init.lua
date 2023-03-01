hs.console.clearConsole()

print = function(...)
  hs.rawprint(...)
  hs.console.printStyledtext(...)
end

local WindowManager = require('.modules.window_manager')
local AlertStyle = require('.modules.alert_style')
local KeyboardManager = require('.modules.keyboard_manager')

local leader = { "ctrl", "cmd" }
local alert_style = AlertStyle.getStyle()

hs.alert.defaultStyle = alert_style

local window_manager = WindowManager.new()
window_manager:start()

local english_source_id = "com.apple.keylayout.ABC"
local keyboard_manager = KeyboardManager.new(english_source_id)

keyboard_manager:start()
hs.keycodes.inputSourceChanged(keyboard_manager.input_source_changed_callback)

hs.hotkey.bind(leader, "r", hs.reload)

hs.alert.show("Hammer spoon loaded")
