local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "Symbols Nerd Font",
  "Pretendard GOV",
  "JuliaMono",
})

config.font_rules = {
  {
    italic = true,
    font = wezterm.font_with_fallback({
      { family = "Victor Mono", style = "Italic", weight = "Medium" },
      "Symbols Nerd Font",
      "Pretendard GOV",
      "JuliaMono",
    }),
  },
  {
    italic = true,
    intensity = "Bold",
    font = wezterm.font_with_fallback({
      { family = "Victor Mono", style = "Italic", weight = "Bold" },
      "Symbols Nerd Font",
      "Pretendard GOV",
      "JuliaMono",
    }),
  },
}

config.font_size = 13.0
config.line_height = 1.2

config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
config.window_decorations = "TITLE | RESIZE | MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR"
config.hide_tab_bar_if_only_one_tab = true

config.set_environment_variables = {
  LC_TERMINAL_GLYPHS = "nerdfont",
}

config.color_scheme_dirs = {
  os.getenv("HOME") .. "/.local/state/wezterm/colorschemes",
}

local colors_path = os.getenv("HOME") .. "/.local/state/wezterm/colorschemes/colors.toml"
wezterm.add_to_config_reload_watch_list(colors_path)
local f = io.open(colors_path, "r")
if f then
  f:close()
  config.color_scheme = "colors"
else
  config.color_scheme = "Modus-Vivendi"
end

return config
