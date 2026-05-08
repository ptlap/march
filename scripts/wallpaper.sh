#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
state_dir="$repo_dir/state"
generated_dir="$repo_dir/themes/generated"
palette_config="$repo_dir/rofi/command-palette.rasi"
wallpaper_dirs="${MARCH_WALLPAPER_DIRS:-$repo_dir/wallpapers:$HOME/Pictures/Wallpapers}"
matugen_json="$generated_dir/matugen.json"
march_colors_json="$generated_dir/march-colors.json"
rofi_colors="$generated_dir/rofi-colors.rasi"

usage() {
    cat <<'EOF'
Usage:
  wallpaper.sh --pick
  wallpaper.sh --random
  wallpaper.sh --apply <image>
  wallpaper.sh --generate-theme

Environment:
  MARCH_WALLPAPER_DIRS  Colon-separated wallpaper directories.
EOF
}

notify() {
    notify-send "march wallpaper" "$1" 2>/dev/null || printf '%s\n' "$1" >&2
}

notify_applied() {
    local image="$1"
    local accent="${2:-}"
    local message="Applied $(basename "$image")"

    if [[ -n "$accent" ]]; then
        message="$message\nAccent $accent"
    fi

    notify-send -i "$image" "march wallpaper" "$message" 2>/dev/null || printf '%b\n' "$message" >&2
}

ensure_dirs() {
    mkdir -p "$state_dir" "$generated_dir" "$repo_dir/wallpapers"

    if [[ ! -f "$rofi_colors" ]]; then
        printf '* {}\n' > "$rofi_colors"
    fi
}

list_wallpapers() {
    IFS=':' read -r -a dirs <<< "$wallpaper_dirs"

    for dir in "${dirs[@]}"; do
        [[ -d "$dir" ]] || continue
        find "$dir" -type f \( \
            -iname '*.jpg' -o \
            -iname '*.jpeg' -o \
            -iname '*.png' -o \
            -iname '*.webp' -o \
            -iname '*.avif' -o \
            -iname '*.bmp' -o \
            -iname '*.gif' \
        \)
    done | sort -u
}

pick_wallpaper() {
    local selected

    selected="$(
        list_wallpapers | rofi -dmenu \
            -config "$palette_config" \
            -p "wallpaper" \
            -mesg "Local wallpapers from ./wallpapers and ~/Pictures/Wallpapers"
    )"

    [[ -n "$selected" ]] || exit 0
    apply_wallpaper "$selected"
}

random_wallpaper() {
    local selected

    selected="$(list_wallpapers | shuf -n 1)"
    if [[ -z "$selected" ]]; then
        notify "No local wallpapers found"
        exit 1
    fi

    apply_wallpaper "$selected"
}

generate_palette() {
    local image="$1"
    local matugen_tmp="$generated_dir/matugen.json.tmp"

    if ! command -v matugen >/dev/null 2>&1; then
        notify "Wallpaper applied. matugen is not installed, skipped colors."
        return 0
    fi

    if ! matugen image "$image" \
        --mode dark \
        --type scheme-tonal-spot \
        --source-color-index 0 \
        --json hex \
        > "$matugen_tmp" \
        2> "$generated_dir/matugen.log"; then
        rm -f "$matugen_tmp"
        notify "Wallpaper applied. matugen failed, skipped colors."
    else
        mv "$matugen_tmp" "$matugen_json"
        rm -f "$generated_dir/matugen.log"
        write_generated_palette
    fi
}

hex_to_rofi_rgba() {
    local hex="${1#"#"}"
    local alpha="$2"

    printf 'rgba(%d, %d, %d, %s%%)' \
        "0x${hex:0:2}" \
        "0x${hex:2:2}" \
        "0x${hex:4:2}" \
        "$alpha"
}

hex_to_qml_argb() {
    local hex="${1#"#"}"
    local alpha="$2"

    printf '#%s%s' "$alpha" "$hex"
}

write_generated_palette() {
    if [[ ! -f "$matugen_json" ]]; then
        notify "No matugen palette found yet"
        return 1
    fi

    if ! command -v jq >/dev/null 2>&1; then
        notify "Wallpaper applied. jq is not installed, skipped generated theme."
        return 0
    fi

    local bg bg_soft text text_muted text_dim accent accent2 accent3 error
    bg="$(jq -r '.colors.background.dark.color // "#0B0D12"' "$matugen_json")"
    bg_soft="$(jq -r '.colors.surface_container.dark.color // .colors.surface.dark.color // "#11141B"' "$matugen_json")"
    text="$(jq -r '.colors.on_surface.dark.color // "#F2F4F8"' "$matugen_json")"
    text_muted="$(jq -r '.colors.on_surface_variant.dark.color // "#A8B0C0"' "$matugen_json")"
    text_dim="$(jq -r '.colors.outline.dark.color // "#6F7787"' "$matugen_json")"
    accent="$(jq -r '.colors.primary.dark.color // "#8AADF4"' "$matugen_json")"
    accent2="$(jq -r '.colors.secondary.dark.color // "#C6A0F6"' "$matugen_json")"
    accent3="$(jq -r '.colors.tertiary.dark.color // "#91D7E3"' "$matugen_json")"
    error="$(jq -r '.colors.error.dark.color // "#ED8796"' "$matugen_json")"

    jq -n \
        --arg bg "$bg" \
        --arg bgSoft "$bg_soft" \
        --arg surface "$(hex_to_qml_argb "$bg_soft" "85")" \
        --arg surfaceStrong "$(hex_to_qml_argb "$bg_soft" "ad")" \
        --arg glassBg "$(hex_to_qml_argb "$bg" "75")" \
        --arg glassBorder "#24ffffff" \
        --arg glassHighlight "#38ffffff" \
        --arg glassShadow "#59000000" \
        --arg text "$text" \
        --arg textMuted "$text_muted" \
        --arg textDim "$text_dim" \
        --arg accent "$accent" \
        --arg accent2 "$accent2" \
        --arg accent3 "$accent3" \
        --arg success "$accent3" \
        --arg warning "$accent2" \
        --arg error "$error" \
        --arg barBg "$(hex_to_qml_argb "$bg" "94")" \
        --arg barBorder "#21ffffff" \
        --arg barActive "$(hex_to_qml_argb "$accent" "66")" \
        --arg barHover "#1affffff" \
        '{
            bg: $bg,
            bgSoft: $bgSoft,
            surface: $surface,
            surfaceStrong: $surfaceStrong,
            glassBg: $glassBg,
            glassBorder: $glassBorder,
            glassHighlight: $glassHighlight,
            glassShadow: $glassShadow,
            text: $text,
            textMuted: $textMuted,
            textDim: $textDim,
            accent: $accent,
            accent2: $accent2,
            accent3: $accent3,
            success: $success,
            warning: $warning,
            error: $error,
            barBg: $barBg,
            barBorder: $barBorder,
            barActive: $barActive,
            barHover: $barHover
        }' > "$march_colors_json"

    cat > "$rofi_colors" <<EOF
* {
    bg: $bg;
    surface: $(hex_to_rofi_rgba "$accent" 32);
    glass-bg: $(hex_to_rofi_rgba "$bg" 58);
    glass-border: rgba(255, 255, 255, 13%);
    glass-highlight: rgba(255, 255, 255, 18%);
    text: $text;
    text-muted: $text_muted;
    text-dim: $text_dim;
    accent: $accent;
    accent-2: $accent2;
}

window {
    background-color: $(hex_to_rofi_rgba "$bg" 78);
}

inputbar {
    background-color: rgba(255, 255, 255, 8%);
}

element selected {
    background-color: $(hex_to_rofi_rgba "$accent" 36);
}

button selected {
    background-color: $(hex_to_rofi_rgba "$accent2" 20);
}
EOF
}

apply_wallpaper() {
    local image="$1"

    if [[ ! -f "$image" ]]; then
        notify "Wallpaper not found: $image"
        exit 1
    fi

    ensure_dirs

    printf '%s\n' "$image" > "$state_dir/current-wallpaper"

    if command -v awww >/dev/null 2>&1; then
        awww img "$image" \
            --resize crop \
            --filter Lanczos3 \
            --transition-type grow \
            --transition-duration 0.8 \
            --transition-pos center \
            >/dev/null 2>&1 || true
    fi

    generate_palette "$image"
    local accent=""
    if [[ -f "$march_colors_json" ]] && command -v jq >/dev/null 2>&1; then
        accent="$(jq -r '.accent // empty' "$march_colors_json" 2>/dev/null || true)"
    fi
    notify_applied "$image" "$accent"
}

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
