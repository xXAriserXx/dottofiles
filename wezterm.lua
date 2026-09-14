local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Codex emits a BEL when it needs approval. Bring that exact pane and its
-- containing WezTerm window to the foreground, even from another app/Space.
wezterm.on("bell", function(window, pane)
  local process_name = pane:get_foreground_process_name() or ""
  if process_name:lower():find("codex", 1, true) then
    pane:activate()
    window:focus()
  end
end)

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 25
config.enable_tab_bar = true
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Frappe"
config.enable_scroll_bar = false
config.audible_bell = "SystemBeep"

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
