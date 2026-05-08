#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
palette_config="$repo_dir/rofi/command-palette.rasi"
apps_config="$repo_dir/rofi/app-launcher.rasi"
generated_rofi_theme="$repo_dir/themes/generated/rofi-colors.rasi"
prefix_help="> apps  ! system  @ theme/wallpaper  # workspace  ? help"

require_rofi() {
    if ! command -v rofi >/dev/null 2>&1; then
        notify-send "march launcher" "rofi is not installed" 2>/dev/null || true
        exit 1
    fi
}

ensure_generated_rofi_theme() {
    if [[ -f "$generated_rofi_theme" ]]; then
        return 0
    fi

    mkdir -p "$(dirname "$generated_rofi_theme")"
    cat > "$generated_rofi_theme" <<'EOF'
* {}
EOF
}

pick() {
    printf '%s\n' \
        "> apps" \
        "> kitty" \
        "> files" \
        "! reload hyprland" \
        "! restart march" \
        "! kill quickshell" \
        "! restore end4" \
        "! lock" \
        "! suspend" \
        "@ wallpaper picker" \
        "@ theme picker" \
        "@ random wallpaper" \
        "# workspace 1" \
        "# workspace 2" \
        "# workspace 3" \
        "# workspace 4" \
        "# workspace 5" \
        "# workspace 6" \
        "# workspace 7" \
        "# workspace 8" \
        "# workspace 9" \
        "# workspace 10" \
        "? help" \
        "? keybinds" \
        "? open march repo" |
        rofi -dmenu \
            -config "$palette_config" \
            -p "march" \
            -mesg "$prefix_help"
}

open_apps() {
    exec rofi -show drun -config "$apps_config"
}

require_rofi
ensure_generated_rofi_theme
selection="$(pick || true)"

case "$selection" in
    "> apps")
        open_apps
        ;;
    "> kitty")
        "$repo_dir/scripts/open-kitty.sh" >/tmp/march-kitty.log 2>&1 &
        ;;
    "> files")
        xdg-open "$HOME" >/tmp/march-files.log 2>&1 &
        ;;
    "! reload hyprland")
        hyprctl reload
        ;;
    "! restart march")
        pkill qs 2>/dev/null || true
        qs -c march >/tmp/qs-march.log 2>&1 &
        ;;
    "! kill quickshell")
        pkill qs 2>/dev/null || true
        ;;
    "! restore end4")
        pkill qs 2>/dev/null || true
        qs -c ii >/tmp/qs-ii.log 2>&1 &
        ;;
    "! lock")
        loginctl lock-session
        ;;
    "! suspend")
        systemctl suspend || loginctl suspend
        ;;
    "@ wallpaper picker")
        "$repo_dir/scripts/wallpaper.sh" --pick
        ;;
    "@ random wallpaper")
        "$repo_dir/scripts/wallpaper.sh" --random
        ;;
    "@ theme picker")
        notify-send "march" "theme picker is planned after generated colors are stable" 2>/dev/null || true
        ;;
    "# workspace "*)
        workspace="${selection##* }"
        hyprctl dispatch workspace "$workspace"
        ;;
    "? help")
        notify-send "march prefixes" "$prefix_help" 2>/dev/null || true
        ;;
    "? keybinds")
        xdg-open "$HOME/.config/hypr/custom/keybinds.conf" >/tmp/march-keybinds.log 2>&1 &
        ;;
    "? open march repo")
        kitty --working-directory "$repo_dir" 2>/dev/null &
        ;;
esac
