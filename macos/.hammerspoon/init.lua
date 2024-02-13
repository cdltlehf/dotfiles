local WindowManager = require('.modules.window_manager')
local AlertStyle = require('.modules.alert_style')
local KeyboardManager = require('.modules.keyboard_manager')

local print = function(...)
  hs.rawprint(...)
  hs.console.printStyledtext(...)
end
local modifiers = { "ctrl", "alt" }

hs.console.clearConsole()

local alert_style = AlertStyle.getStyle()
hs.alert.defaultStyle = alert_style

local window_manager = WindowManager.new(modifiers)
window_manager:start()

local english_source_id = "com.apple.keylayout.ABC"
local keyboard_manager = KeyboardManager.new(english_source_id)

keyboard_manager:start()
hs.keycodes.inputSourceChanged(keyboard_manager.input_source_changed_callback)

hs.hotkey.bind(modifiers, "r", hs.reload)
hs.hotkey.bind(
  { "ctrl", "cmd", "shift" }, "l",
  function() hs.alert.show('use ctrl+command-q', 0.5) end
)

hs.alert.show("Hammer spoon loaded")
