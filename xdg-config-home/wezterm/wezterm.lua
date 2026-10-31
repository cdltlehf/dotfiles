local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Modus-Vivendi"

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
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = { left = 6, right = 6, top = 6, bottom = 6 }

config.set_environment_variables = {
  LC_TERMINAL_GLYPHS = "nerdfont",
}

return config
