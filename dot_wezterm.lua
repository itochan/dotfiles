local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Sublette'

config.font = wezterm.font_with_fallback {
  'UDEV Gothic 35',
  'JetBrains Mono',
}
config.font_size = 16.0

config.initial_cols = 120
config.initial_rows = 36

return config
