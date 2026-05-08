#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$script_dir/.." && pwd)"
state_dir="$repo_dir/state"
generated_dir="$repo_dir/themes/generated"
palette_config="$repo_dir/rofi/command-palette.rasi"
wallpaper_dirs="${MARCH_WALLPAPER_DIRS:-$repo_dir/wallpapers:$HOME/Pictures/Wallpapers}"
online_wallpaper_dir="${MARCH_ONLINE_WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
current_wallpaper="$state_dir/current-wallpaper"
wallpaper_history="$state_dir/wallpaper-history"
theme_mode="$state_dir/theme-mode"
matugen_json="$generated_dir/matugen.json"
march_colors_json="$generated_dir/march-colors.json"
rofi_colors="$generated_dir/rofi-colors.rasi"
kitty_colors="$generated_dir/kitty-colors.conf"

usage() {
    cat <<'EOF'
Usage:
  wallpaper.sh --pick
  wallpaper.sh --random
  wallpaper.sh --apply <image>
  wallpaper.sh --current
  wallpaper.sh --previous
  wallpaper.sh --open-folder
  wallpaper.sh --theme-picker
  wallpaper.sh --theme-dynamic
  wallpaper.sh --theme-fallback
  wallpaper.sh --theme-status
  wallpaper.sh --online <osu|konachan|wallhaven-onepiece>
  wallpaper.sh --wallpaper-menu
  wallpaper.sh --generate-theme

Environment:
  MARCH_WALLPAPER_DIRS  Colon-separated wallpaper directories.
  MARCH_ONLINE_WALLPAPER_DIR  Directory for downloaded online wallpapers.
EOF
}

source "$script_dir/lib/wallpaper/core.sh"
source "$script_dir/lib/wallpaper/theme.sh"
source "$script_dir/lib/wallpaper/online.sh"
source "$script_dir/lib/wallpaper/menu.sh"

main() {
    ensure_dirs

    case "${1:-}" in
        --pick)
            pick_wallpaper
            ;;
        --random)
            random_wallpaper
            ;;
        --apply)
            [[ -n "${2:-}" ]] || {
                usage
                exit 2
            }
            apply_wallpaper "$2"
            ;;
        --current)
            show_current_wallpaper
            ;;
        --previous)
            previous_wallpaper
            ;;
        --open-folder)
            open_current_wallpaper_folder
            ;;
        --theme-picker)
            theme_picker
            ;;
        --theme-dynamic)
            enable_dynamic_theme
            ;;
        --theme-fallback)
            enable_fallback_theme
            ;;
        --theme-status)
            theme_status
            ;;
        --online)
            [[ -n "${2:-}" ]] || {
                usage
                exit 2
            }
            download_online_wallpaper "$2"
            ;;
        --wallpaper-menu)
            wallpaper_menu
            ;;
        --generate-theme)
            write_generated_palette
            ;;
        -h|--help|"")
            usage
            ;;
        *)
            usage
            exit 2
            ;;
    esac
}

main "$@"
