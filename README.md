# Cold Fog

A cold, desaturated dark theme for [Omarchy](https://omarchy.org/) — muted blue-greys, low-contrast ANSI colors, and macOS-style squircle window corners.

![Cold Fog wallpaper](backgrounds/1-cold-fog-peak.jpg)

## Install

```bash
omarchy theme install https://github.com/Alexis-Reillo-Segarra/omarchy-cold-fog.git
```

That installs the theme as `cold-fog` and applies it. To install manually instead:

```bash
git clone https://github.com/Alexis-Reillo-Segarra/omarchy-cold-fog.git \
  ~/.config/omarchy/themes/cold-fog
omarchy theme set "Cold Fog"
```

To remove it:

```bash
omarchy theme remove cold-fog
```

## What's in here

| File | Purpose |
|------|---------|
| `colors.toml` | The palette. Omarchy renders every themed config (alacritty, ghostty, foot, kitty, btop, waybar, mako, walker, hyprlock, helix, obsidian, …) from this file at `omarchy theme set` time. |
| `hyprland.conf` | Border colors + the rounded-corner decoration block. Overrides the generated template. |
| `icons.theme` | GTK icon theme (`Yaru-grey`). |
| `neovim.lua` | LazyVim spec — Kanagawa Dragon, transparent background. |
| `vscode.json` | VS Code color theme mapping. |
| `backgrounds/` | Wallpapers. Cycle with `omarchy theme bg next`. |

Anything not shipped here is generated from `colors.toml` using Omarchy's templates in
`~/.local/share/omarchy/default/themed/*.tpl`. To override a generated file, drop a file with the
same name in this repo — theme files always win over templates.

## Palette

`mode = "dark"`

| Role | Hex |
|------|-----|
| Background | `#10171A` |
| Foreground | `#C4D0D2` |
| Accent | `#9FB0B4` |
| Cursor | `#D8E2E4` |
| Selection | `#2A383C` on `#DDE6E8` |

Full ANSI 0–15 in [`colors.toml`](colors.toml).

## Rounded corners

`hyprland.conf` ships macOS-style window corners:

```conf
decoration {
    rounding = 12
    rounding_power = 3.0
}
```

`rounding_power` is what makes this read as macOS rather than "just rounded". At the default `2.0`
the corner is a circular arc; above `2.0` the curve becomes superelliptic — a squircle — and eases
into the straight edge instead of meeting it abruptly. `3.0` is a good middle ground; `4.0` is the
maximum.

Prefer square windows? Delete the `decoration` block — the rest of the theme is unaffected.

Requires Hyprland 0.47+ for `rounding_power` (developed against 0.56).

## Development

The installed copy lives at `~/.config/omarchy/themes/cold-fog` and Omarchy builds
`~/.config/omarchy/current/theme` from it, so editing this repo alone changes nothing on a running
system. After a change:

```bash
cp -r colors.toml hyprland.conf icons.theme neovim.lua vscode.json backgrounds \
  ~/.config/omarchy/themes/cold-fog/
omarchy theme set "Cold Fog"
```

Add `OMARCHY_THEME_SKIP_BACKGROUND=1` in front of `omarchy theme set` to keep your current wallpaper
instead of rotating to the theme's first background.

Validate Hyprland changes with:

```bash
hyprctl reload && hyprctl configerrors
```

## Wallpaper

`backgrounds/1-cold-fog-peak.jpg` is a royalty-free image, redistributed here with permission of its
license terms. It carries no attribution requirement.

## License

[MIT](LICENSE).
