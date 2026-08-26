#!/usr/bin/env bash
#
# Install Cold Fog and the desktop config that ships alongside it.
#
#   ./install.sh              everything below, then apply
#   ./install.sh --theme-only just the palette, icons and wallpaper
#   ./install.sh --no-apply   install everything, skip `omarchy theme set`
#
# The full install covers the theme, the theme hooks, the Hyprland look'n'feel,
# the bar layout and the terminal configs. `omarchy theme install` alone gets
# you the palette and nothing else: it deliberately refuses to stage anything
# from a cloned repo that runs code, so neovim.lua, vscode.json and every hook
# are dropped, and the rest lives outside the theme directory entirely.
#
# Monitors are deliberately NOT installed -- see desktop/hypr/monitors.lua.example.
# Everything this script overwrites is backed up next to the original first.

set -euo pipefail

readonly REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly THEME_SLUG="cold-fog"
readonly THEME_DIR="$HOME/.config/omarchy/themes/$THEME_SLUG"
readonly HOOKS_DIR="$HOME/.config/omarchy/hooks"
readonly HYPR_DIR="$HOME/.config/hypr"
readonly STAMP="$(date +%Y%m%d%H%M%S)"

theme_only=0
apply=1
for arg in "$@"; do
  case "$arg" in
    --theme-only) theme_only=1 ;;
    --no-apply)   apply=0 ;;
    -h|--help)    sed -n '3,${/^[^#]/q;p;}' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

info()  { echo -e "\e[0;34m[INFO]\e[0m $1"; }
ok()    { echo -e "\e[32m[OK]\e[0m $1"; }
warn()  { echo -e "\e[0;33m[WARN]\e[0m $1"; }

command -v omarchy >/dev/null || { echo "omarchy not found -- this needs an Omarchy system." >&2; exit 1; }

# Back up a path in place before it is replaced.
backup() {
  local target="$1"
  [[ -e $target ]] || return 0
  cp -r "$target" "$target.bak.$STAMP"
  info "Backed up $(basename "$target") -> $(basename "$target").bak.$STAMP"
}

install_theme() {
  mkdir -p "$THEME_DIR/backgrounds"
  # Copied, not symlinked, and without the repo's .git: Omarchy treats a theme
  # directory carrying .git as untrusted and strips neovim.lua and vscode.json.
  cp "$REPO/colors.toml" "$REPO/icons.theme" "$REPO/neovim.lua" "$REPO/vscode.json" "$THEME_DIR/"
  # Replace the backgrounds wholesale so a wallpaper dropped by an older
  # version of this theme does not stay in the rotation.
  find "$THEME_DIR/backgrounds" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  cp "$REPO"/backgrounds/* "$THEME_DIR/backgrounds/"
  ok "Theme installed to $THEME_DIR"
}

install_hooks() {
  mkdir -p "$HOOKS_DIR/theme-set.d"

  if [[ -f $HOOKS_DIR/theme-set ]] && ! cmp -s "$REPO/desktop/hooks/theme-set" "$HOOKS_DIR/theme-set"; then
    backup "$HOOKS_DIR/theme-set"
  fi
  install -m 755 "$REPO/desktop/hooks/theme-set" "$HOOKS_DIR/theme-set"

  local src name
  for src in "$REPO"/desktop/hooks/theme-set.d/*.sh; do
    name=$(basename "$src")
    if [[ -f $HOOKS_DIR/theme-set.d/$name ]] && ! cmp -s "$src" "$HOOKS_DIR/theme-set.d/$name"; then
      backup "$HOOKS_DIR/theme-set.d/$name"
    fi
    install -m 755 "$src" "$HOOKS_DIR/theme-set.d/$name"
  done
  ok "Theme hooks installed to $HOOKS_DIR"
  info "Each hooklet retints one app and skips silently when that app is absent."
}

install_looknfeel() {
  mkdir -p "$HYPR_DIR"
  if [[ -f $HYPR_DIR/looknfeel.lua ]] && ! cmp -s "$REPO/desktop/hypr/looknfeel.lua" "$HYPR_DIR/looknfeel.lua"; then
    backup "$HYPR_DIR/looknfeel.lua"
    warn "looknfeel.lua replaced -- your previous version is in the backup beside it."
  fi
  install -m 644 "$REPO/desktop/hypr/looknfeel.lua" "$HYPR_DIR/looknfeel.lua"
  ok "Hyprland look'n'feel installed (rounding, gaps, blur)"
}

install_bar() {
  local target="$HOME/.config/omarchy/shell.json"
  mkdir -p "$(dirname "$target")"
  if [[ -f $target ]] && ! cmp -s "$REPO/desktop/omarchy/shell.json" "$target"; then
    backup "$target"
  fi
  install -m 600 "$REPO/desktop/omarchy/shell.json" "$target"
  ok "Bar layout installed (media + microphone widgets, dd/MM clock)"
}

install_terminals() {
  # Omarchy themes all four terminals from colors.toml; these configs carry the
  # parts a theme cannot: font, padding, keybindings, and the 0.62 background
  # opacity that makes the palette read the way it is meant to.
  local pairs=(
    "alacritty.toml:$HOME/.config/alacritty/alacritty.toml"
    "foot.ini:$HOME/.config/foot/foot.ini"
    "ghostty.config:$HOME/.config/ghostty/config"
    "kitty.conf:$HOME/.config/kitty/kitty.conf"
  )
  local pair src target
  for pair in "${pairs[@]}"; do
    src="$REPO/desktop/terminals/${pair%%:*}"
    target="${pair#*:}"
    mkdir -p "$(dirname "$target")"
    if [[ -f $target ]] && ! cmp -s "$src" "$target"; then
      backup "$target"
    fi
    install -m 644 "$src" "$target"
  done
  ok "Terminal configs installed (alacritty, foot, ghostty, kitty)"
}

install_theme
if (( theme_only == 0 )); then
  install_hooks
  install_looknfeel
  install_bar
  install_terminals
fi

if (( apply )); then
  info "Applying theme..."
  omarchy theme set "Cold Fog"
  hyprctl reload >/dev/null 2>&1 || true
  if (( theme_only == 0 )); then
    omarchy restart terminal >/dev/null 2>&1 || true
    omarchy restart shell >/dev/null 2>&1 || true
  fi
  ok "Cold Fog applied."
  (( theme_only )) || info "foot only picks up its config in new windows -- open a fresh terminal."
else
  info "Skipped applying. Run: omarchy theme set \"Cold Fog\""
fi
