_G.config_watcher = hs.pathwatcher.new(hs.configdir, hs.reload):start()

local WindowManager = require(".modules.window_manager")
local modifiers = { "ctrl", "alt" }

local window_manager = WindowManager.new(modifiers)
window_manager:start()

hs.hotkey.bind(modifiers, "r", hs.reload)
hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "l", function()
  hs.alert.show("use ctrl+command-q", 0.5)
end)

hs.alert.show("Config loaded")
