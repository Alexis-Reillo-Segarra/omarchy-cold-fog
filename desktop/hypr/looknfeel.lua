-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
    -- Bigger gaps = smaller windows (Omarchy defaults are gaps_in = 5, gaps_out = 10).
    gaps_in = 8,
    gaps_out = 30,

    -- Default Hyprland/Omarchy layout: everything fits on screen, no side-scrolling.
    layout = "dwindle",
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
  decoration = {
    -- macOS-style corners: a generous radius plus a squircle curve. rounding_power
    -- above 2.0 makes the corner superelliptic rather than a circular arc, which is
    -- what distinguishes macOS rounding from a plain rounded rectangle. Part of the
    -- Cold Fog look; set rounding = 0 for square windows.
    rounding = 12,
    rounding_power = 3.0,

    -- Omarchy ships blur disabled. Enabled here because Cold Fog's near-black
    -- background reads better with the wallpaper showing through. Omarchy 3 used
    -- brightness 0.60 / contrast 0.75, which darkened the backdrop before
    -- translucing it and ate most of the effect; raised so what is behind the
    -- windows actually shows.
    blur = {
      enabled = true,
      brightness = 0.90,
      contrast = 0.90,
    },
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- Disabled: the scrolling layout is what made windows slide off to the side.
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })
