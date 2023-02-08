local wezterm = require 'wezterm'
local act = wezterm.action
return {
  -- transparent background
  window_background_opacity = 1.0,
  -- theme
  color_scheme = "Qualia (base16)",

  -- have a basic local mux connection so `wezterm connect unix` can be used
  unix_domains = {
    {
      name = 'unix',
    },
  },

  -- use shift up/down to nqvigate between prompts
  -- requires OSC-133 use by shell
  keys = {
    { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
  },

  -- select command output with 4 clicks
  -- requires OSC-133 use by shell
  mouse_bindings = {
    {
      event = { Down = { streak = 4, button = 'Left' } },
      action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
      mods = 'NONE',
    },
  },
}
