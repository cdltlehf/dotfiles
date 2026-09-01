local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.font = wezterm.font_with_fallback({ "JetBrains Mono", "Symbols Nerd Font", "D2Coding" })
config.font_size = 13.0
config.line_height = 1.2
config.set_environment_variables = {
	LC_TERMINAL_GLYPHS = "nerdfont",
}

-- OSX liquid glass material thick
config.window_background_opacity = 0.9
config.macos_window_background_blur = 999
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = { left = 6, right = 6, top = 50, bottom = 6 }
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
local colors_path = os.getenv("HOME") .. "/.local/state/wezterm/colorschemes/colors.toml"
wezterm.add_to_config_reload_watch_list(colors_path)
local f = io.open(colors_path, "r")
if f then
	f:close()
	config.color_scheme = "colors"
else
	config.color_scheme = "Modus Vivendi"
end

return config
