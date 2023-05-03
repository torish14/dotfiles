-- WezTerm
-- https://wezfurlong.org/wezterm/

local wezterm = require 'wezterm'
local act = wezterm.action
-- The art is a bit too bright and colorful to be useful as a backdrop
-- for text, so we're going to dim it down to 10% of its normal brightness
local dimmer = { brightness = 0.1 }

return {
  check_for_updates = false,

  use_ime = true,
  -- Smart tab bar [distraction-free mode]
  hide_tab_bar_if_only_one_tab = false,

  warn_about_missing_glyphs = false,

  -- Cursor style
  animation_fps = 1,

  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  -- cursor_blink_rate = 0,
  default_cursor_style = 'BlinkingBlock',
  -- default_cursor_style = 'BlinkingBar',

  enable_wayland = false,

  -- selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",

  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  },

  use_fancy_tab_bar = false,

  tab_bar_at_bottom = false,

  -- Color theme
  -- https://wezfurlong.org/wezterm/config/appearance.html

  color_scheme = 'Dracula',

  window_background_opacity = 0.8,

  text_background_opacity = 0.5,

  window_background_image = '',

  front_end = "WebGpu",

  initial_cols = 260,
  initial_rows = 65,

  -- Font configuration
  -- https://wezfurlong.org/wezterm/config/fonts.html
  -- font = wezterm.font ('Fira Code', 'Menlo', 'Monaco', 'Courier New', 'monospace'),
  font = wezterm.font 'Menlo',
  font = wezterm.font 'Monaco',
  font = wezterm.font('Courier New'),
  font = wezterm.font('monospace'),
  font = wezterm.font('Hack Nerd Font'),
  -- font = wezterm.font 'Fira Code',
  font_size = 14.0,

  scrollback_lines = 20000,

  -- Disable ligatures
  -- https://wezfurlong.org/wezterm/config/font-shaping.html
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },

  -- Enable CSI u mode
  -- https://wezfurlong.org/wezterm/config/lua/config/enable_csi_u_key_encoding.html
  enable_csi_u_key_encoding = true,

  -- disable_default_key_bindings = true,

  leader = { key="s", mods="CTRL" },

  -- Avoid unexpeced config breakage and unusable terminal
  automatically_reload_config = false,

  enable_scroll_bar = true,

  min_scroll_bar_height = '2cell',

  colors = {
    scrollbar_thumb = 'white',
    cursor_bg = '#a277ff',
    cursor_fg = '#edecee',
    cursor_border = '#a277ff',
    selection_fg = '#edecee',
    selection_bg = '#a277ff',
  },

  background = {
    -- This is the deepest/back-most layer. It will be rendered first
    {
      source = {
        File = '/Users/torish14/Documents14/Alien_Ship_bg_vert_images/Backgrounds/spaceship_bg_1.png',
      },
      -- The texture tiles vertically but not horizontally.
      -- When we repeat it, mirror it so that it appears "more seamless".
      -- An alternative to this is to set `width = "100%"` and have
      -- it stretch across the display
      repeat_x = 'Mirror',
      hsb = dimmer,
      -- When the viewport scrolls, move this layer 10% of the number of
      -- pixels moved by the main viewport. This makes it appear to be
      -- further behind the text.
      attachment = { Parallax = 0.1 },
    },
    -- Subsequent layers are rendered over the top of each other
    {
      source = {
        File = '/Users/torish14/Documents14/Alien_Ship_bg_vert_images/Overlays/overlay_1_spines.png',
      },
      width = '100%',
      repeat_x = 'NoRepeat',

      -- position the spins starting at the bottom, and repeating every
      -- two screens.
      vertical_align = 'Bottom',
      repeat_y_size = '200%',
      hsb = dimmer,

      -- The parallax factor is higher than the background layer, so this
      -- one will appear to be closer when we scroll
      attachment = { Parallax = 0.2 },
    },
    {
      source = {
        File = '/Users/torish14/Documents14/Alien_Ship_bg_vert_images/Overlays/overlay_2_alienball.png',
      },
      width = '100%',
      repeat_x = 'NoRepeat',

      -- start at 10% of the screen and repeat every 2 screens
      vertical_offset = '10%',
      repeat_y_size = '200%',
      hsb = dimmer,
      attachment = { Parallax = 0.3 },
    },
    {
      source = {
        File = '/Users/torish14/Documents14/Alien_Ship_bg_vert_images/Overlays/overlay_3_lobster.png',
      },
      width = '100%',
      repeat_x = 'NoRepeat',

      vertical_offset = '30%',
      repeat_y_size = '200%',
      hsb = dimmer,
      attachment = { Parallax = 0.4 },
    },
    {
      source = {
        File = '/Users/torish14/Documents14/Alien_Ship_bg_vert_images/Overlays/overlay_4_spiderlegs.png',
      },
      width = '100%',
      repeat_x = 'NoRepeat',

      vertical_offset = '50%',
      repeat_y_size = '150%',
      hsb = dimmer,
      attachment = { Parallax = 0.5 }
    }
  },
  keys = {
    {
      key = "t", mods = "CMD", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" })
    },
    {
      key = "d", mods = "CMD", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } })
    },
    {
      key = "h", mods = "CMD", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } })
    },
    {
      key = "w", mods = "CMD", action = wezterm.action({ CloseCurrentPane = { confirm = false } })
    },
    {
      key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = false } })
    },
    {
      key = "z", mods = "LEADER", action = "TogglePaneZoomState"
    },
    {
      key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" })
    },
    {
      key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" })
    },
    {
      key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" })
    },
    {
      key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" })
    },
    {
      key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" })
    },
    {
      key = "H", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } })
    },
    {
      key = "J", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } })
    },
    {
      key = "K", mods = "LEADER", action = wezterm.action({ AdjustPaneSize= { "Up", 5 } })
    },
    {
      key = "L", mods = "LEADER", action = wezterm.action({ AdjustPaneSize= { "Right", 5 } })
    },
    { key = "1", mods = "LEADER", action=wezterm.action{ ActivateTab=0 }},
    { key = "2", mods = "LEADER", action=wezterm.action{ ActivateTab=1 }},
    { key = "3", mods = "LEADER", action=wezterm.action{ ActivateTab=2 }},
    { key = "4", mods = "LEADER", action=wezterm.action{ ActivateTab=3 }},
    { key = "5", mods = "LEADER", action=wezterm.action{ ActivateTab=4 }},
    { key = "6", mods = "LEADER", action=wezterm.action{ ActivateTab=5 }},
    { key = "7", mods = "LEADER", action=wezterm.action{ ActivateTab=6 }},
    { key = "8", mods = "LEADER", action=wezterm.action{ ActivateTab=7 }},
    { key = "9", mods = "LEADER", action=wezterm.action{ ActivateTab=8 }},
    { key = "0", mods = "CMD", action = "ResetFontSize" },
    { key = "^", mods = "CMD", action = "IncreaseFontSize" },
    { key = "-", mods = "CMD", action = "DecreaseFontSize" },
    { key = 'V', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
    { key = 'V', mods = 'CMD', action = act.PasteFrom 'PrimarySelection' },

  }
}
