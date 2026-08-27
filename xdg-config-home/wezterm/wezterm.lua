local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "JetBrains Mono", "D2Coding" })
config.font_size = 13.0
config.line_height = 1.2
config.set_environment_variables = {
	CHARSET = "nerdfont",
}

-- OSX liquid glass material thick
config.window_background_opacity = 0.9
config.macos_window_background_blur = 999
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = { top = 50 }
config.native_macos_fullscreen_mode = true

config.keys = {
	{
		key = "f",
		mods = "CTRL|CMD",
		action = wezterm.action.ToggleFullScreen,
	},
}

config.color_scheme_dirs = {
	os.getenv("HOME") .. "/.local/state/wezterm/colorschemes",
}

config.automatically_reload_config = true
wezterm.add_to_config_reload_watch_list(os.getenv("HOME") .. "/.local/state/wezterm/colorschemes/colors.toml")
config.color_scheme = "colors"

return config
