# Cold Fog

A cold, desaturated dark theme for [Omarchy](https://omarchy.org/) — muted blue-greys, low-contrast
ANSI colors, and macOS-style squircle window corners.

![Cold Fog wallpaper](backgrounds/1-cold-fog-peak.jpg)

Built for **Omarchy 4** (developed against 4.0.0.alpha / Hyprland 0.56.2). Omarchy 4 moved Hyprland
config from `.conf` to Lua and now renders a theme's Hyprland settings from `colors.toml`, so this
theme no longer ships a `hyprland.conf` — see [Window borders](#window-borders) below.

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
| `colors.toml` | The palette, plus the Hyprland border colors. Omarchy renders every themed config (alacritty, ghostty, foot, kitty, btop, helix, obsidian, the shell/bar, hyprlock, VS Code, Neovim, …) from this file at `omarchy theme set` time. |
| `icons.theme` | GTK icon theme (`Yaru-grey`). |
| `neovim.lua` | LazyVim spec — Kanagawa Dragon, transparent background. Opt-in, see [Files Omarchy drops on install](#files-omarchy-drops-on-install). |
| `vscode.json` | Points VS Code at its built-in `Default Dark Modern`. Opt-in, same caveat. |
| `backgrounds/` | Wallpapers. Cycle with `omarchy theme bg next`. |

Anything not shipped here is generated from `colors.toml` using Omarchy's templates in
`/usr/share/omarchy/default/themed/*.tpl`. To override a generated file, drop a file with the same
name in this repo — theme files win over templates, subject to the caveat below.

## Palette

`mode = "dark"`

| Role | Hex |
|------|-----|
| Background | `#10171A` |
| Foreground | `#C4D0D2` |
| Accent | `#9FB0B4` |
| Cursor | `#D8E2E4` |
| Active border | `#9FB0B4` |
| Inactive border | `#283638` |
| Selection | `#DDE6E8` on `#2A383C` |

Full ANSI 0–15 in [`colors.toml`](colors.toml).

## Window borders

Omarchy 3 let a theme ship a `hyprland.conf` with a raw `general { col.active_border = … }` block.
Omarchy 4 generates the theme's `hyprland.lua` from `default/themed/hyprland.lua.tpl`, which reads
two optional keys out of `colors.toml`:

```toml
hyprland_active_border   = "rgb(9FB0B4)"
hyprland_inactive_border = "rgb(283638)"
```

Both accept a single color or a Hyprland gradient (`"rgba(798186ee) rgba(caccccee) 45deg"`). Omit
either and Omarchy falls back to `accent` for the active border and Hyprland's grey
`rgba(595959aa)` for the inactive one.

Cold Fog sets only `hyprland_inactive_border`. Its active border is the accent, which is already the
fallback — and `hyprland_active_border` does double duty in `shell.toml`, where it also feeds
`active-border-foreground`. Setting it there would pull the bar's accent text off `foreground`
(`#C4D0D2`) and onto the dimmer border grey, so the key is left alone on purpose.

## Rounded corners

Cold Fog is designed around macOS-style squircle corners. These are a *global* look'n'feel setting,
not a per-theme one, so they live in your own config rather than in this repo. Add to
`~/.config/hypr/looknfeel.lua`:

```lua
hl.config({
  decoration = {
    rounding = 12,
    rounding_power = 3.0,
  },
})
```

`rounding_power` is what makes this read as macOS rather than "just rounded". At the default `2.0`
the corner is a circular arc; above `2.0` the curve becomes superelliptic — a squircle — and eases
into the straight edge instead of meeting it abruptly. `3.0` is a good middle ground; `4.0` is the
maximum. Requires Hyprland 0.47+.

Prefer square windows? Leave `looknfeel.lua` alone — the rest of the theme is unaffected.

## Files Omarchy drops on install

When a theme is installed from a git repo, Omarchy 4 refuses to stage anything that runs code,
because a theme from a stranger should not be able to execute anything. That means every `*.lua`
(so `neovim.lua`), the terminal configs `alacritty.toml` / `foot.ini` / `ghostty.conf` /
`kitty.conf`, and `vscode.json`. Omarchy names the skipped files on stderr:

```
Ignored in ~/.config/omarchy/themes/cold-fog: neovim.lua vscode.json
```

That message is expected and harmless — Omarchy regenerates equivalents from `colors.toml`, so you
get an `aether.nvim` colorscheme and a generated VS Code theme built from the Cold Fog palette.
Everything else in this repo — the palette, the borders, `icons.theme`, the backgrounds — installs
normally.

Omarchy tells a repo-installed theme from a hand-written one by the `.git` directory the clone
leaves behind. To opt into the shipped `neovim.lua` and `vscode.json`, copy the files in without it:

```bash
mkdir -p ~/.config/omarchy/themes/cold-fog
cp -r colors.toml icons.theme neovim.lua vscode.json backgrounds \
  ~/.config/omarchy/themes/cold-fog/
omarchy theme set "Cold Fog"
```

## Development

The installed copy lives at `~/.config/omarchy/themes/cold-fog`, and Omarchy builds
`~/.local/state/omarchy/current/theme` from it, so editing this repo alone changes nothing on a
running system. After a change, sync and re-apply with the `cp` above, then:

```bash
omarchy theme set "Cold Fog"
```

Add `OMARCHY_THEME_SKIP_BACKGROUND=1` in front of it to keep your current wallpaper instead of
rotating to the theme's first background.

Verify what actually landed:

```bash
hyprctl getoption general:col.active_border
hyprctl getoption general:col.inactive_border
hyprctl configerrors
```

## Wallpaper

`backgrounds/1-cold-fog-peak.jpg` is a royalty-free image, redistributed here with permission of its
license terms. It carries no attribution requirement.

## License

[MIT](LICENSE).
