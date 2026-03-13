local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 25
config.enable_tab_bar = true
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Frappe"
config.enable_scroll_bar = false

config.keys = {
  -- Tab movement
  { key = "e", mods = "CMD", action = wezterm.action.MoveTabRelative(-1) },
  { key = "r", mods = "CMD", action = wezterm.action.MoveTabRelative(1) },

  -- Faster Scrolling (5 lines at a time)
  { key = "s", mods = "CMD", action = wezterm.action.ScrollByLine(-5) },
  { key = "x", mods = "CMD", action = wezterm.action.ScrollByLine(5) },

  -- Scroll to Top/Bottom (CMD + SHIFT)
  { key = "s", mods = "CMD|SHIFT", action = wezterm.action.ScrollToTop },
  { key = "x", mods = "CMD|SHIFT", action = wezterm.action.ScrollToBottom },
}

config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 0
}

return config