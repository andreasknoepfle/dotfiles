-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- or, changing the font size and color scheme.
config.font_size = 18
config.line_height = 1.1
config.font = wezterm.font 'Fira Code'

config.command_palette_font_size = 18.0
config.color_scheme = 'Molokai (Gogh)'

config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.show_tab_index_in_tab_bar = false
-- not available yet on main build -- config.show_close_tab_button_in_tabs = false
config.keys = {
  { 
	  key = 'w',
	  mods = 'CMD',
	  action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  { 
	  key = 'd',
	  mods = 'CMD',
	  action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  { 
	  key = 'd',
	  mods = 'CMD|SHIFT',
	  action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
	{ 
   	key = 'p', 
    mods = 'CMD|SHIFT', 
    action = wezterm.action.ActivateCommandPalette
  },
-- Cycle to the next pane
    {key="RightArrow", mods="CMD", action=wezterm.action{ActivatePaneDirection="Next"}},
-- Cycle to the previous pane
    {key="LeftArrow", mods="CMD", action=wezterm.action{ActivatePaneDirection="Prev"}},
}

-- Finally, return the configuration to wezterm:
return config
