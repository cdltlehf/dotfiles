hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("ReloadConfiguration", {
	config = {
		reloadOnSpoonUpdate = true,
		watchPaths = { hs.configdir .. "/modules/" },
	},
	start = true,
})

local WindowManager = require(".modules.window_manager")

local spoonInstallPath = hs.configdir .. "/Spoons/SpoonInstall.spoon"
local modifiers = { "ctrl", "alt" }

local window_manager = WindowManager.new(modifiers)
window_manager:start()

hs.hotkey.bind(modifiers, "r", hs.reload)
hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "l", function()
	hs.alert.show("use ctrl+command-q", 0.5)
end)

hs.alert.show("Config loaded")
