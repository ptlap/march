#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
fuzzel_config="$repo_dir/fuzzel/fuzzel.ini"
rofi_config="$repo_dir/rofi/config.rasi"

pick() {
    printf '%s\n' \
        "Apps" \
        "Reload Hyprland" \
        "Restart march shell" \
        "Kill Quickshell" \
        "Restore End-4 shell" \
        "Wallpaper picker" \
        "Theme picker" \
        "Open march repo" |
        fuzzel --dmenu \
            --config "$fuzzel_config" \
            --prompt "march " \
            --placeholder "Command palette"
}

open_apps() {
    if command -v rofi >/dev/null 2>&1; then
        exec rofi -show drun -config "$rofi_config"
    fi

    exec fuzzel --config "$fuzzel_config"
}

selection="$(pick || true)"

case "$selection" in
    "Apps")
        open_apps
        ;;
    "Reload Hyprland")
        hyprctl reload
        ;;
    "Restart march shell")
        pkill qs 2>/dev/null || true
        qs -c march >/tmp/qs-march.log 2>&1 &
        ;;
    "Kill Quickshell")
        pkill qs 2>/dev/null || true
        ;;
    "Restore End-4 shell")
        pkill qs 2>/dev/null || true
        qs -c ii >/tmp/qs-ii.log 2>&1 &
        ;;
    "Wallpaper picker" | "Theme picker")
        notify-send "march" "$selection is planned for a later phase" 2>/dev/null || true
        ;;
    "Open march repo")
        kitty --working-directory "$repo_dir" 2>/dev/null &
        ;;
esac
