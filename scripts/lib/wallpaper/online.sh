download_online_wallpaper() {
    local source="${1:-}"

    case "$source" in
        osu)
            download_osu_wallpaper
            ;;
        konachan)
            download_konachan_wallpaper
            ;;
        wallhaven-onepiece|wallhaven|onepiece)
            download_wallhaven_onepiece_wallpaper
            ;;
        *)
            notify "Unknown online source: ${source:-empty}"
            exit 2
            ;;
    esac
}

download_to_wallpapers() {
    local url="$1"
    local prefix="$2"
    local ext="${url%%\?*}"
    ext="${ext##*.}"

    case "$ext" in
        jpg|jpeg|png|webp|avif) ;;
        *) ext="jpg" ;;
    esac

    local save_dir file
    save_dir="$online_wallpaper_dir"
    mkdir -p "$save_dir"
    file="$save_dir/${prefix}_$(date +%Y%m%d_%H%M%S).$ext"

    curl -fL "$url" -o "$file"
    printf '%s\n' "$file"
}

download_osu_wallpaper() {
    require_online_tools

    local response count index url file
    response="$(curl -fsSL "https://osu.ppy.sh/api/v2/seasonal-backgrounds")"
    count="$(jq -r '.backgrounds | length' <<< "$response")"
    if [[ -z "$count" || "$count" == "0" ]]; then
        notify "osu returned no wallpapers"
        exit 1
    fi

    index=$((RANDOM % count))
    url="$(jq -r ".backgrounds[$index].url" <<< "$response")"
    file="$(download_to_wallpapers "$url" "osu_seasonal")"
    apply_wallpaper "$file"
}

download_konachan_wallpaper() {
    require_online_tools

    local page response url file
    page=$((1 + RANDOM % 1000))
    response="$(curl -fsSL "https://konachan.net/post.json?tags=rating%3Asafe&limit=1&page=$page")"
    url="$(jq -r '.[0].file_url // empty' <<< "$response")"
    if [[ -z "$url" ]]; then
        notify "Konachan returned no safe wallpaper"
        exit 1
    fi

    file="$(download_to_wallpapers "$url" "konachan_safe")"
    apply_wallpaper "$file"
}

download_wallhaven_onepiece_wallpaper() {
    require_online_tools

    local history page api json url file
    history="$state_dir/wallhaven-onepiece-history"
    touch "$history"

    page=$((RANDOM % 20 + 1))
    api="https://wallhaven.cc/api/v1/search?q=one%20piece&categories=010&purity=100&sorting=random&resolutions=1920x1080&ratios=16x9&page=$page"
    json="$(curl -fsSL "$api")"
    url="$(
        {
            jq -r '.data[].path' <<< "$json" |
                grep -vxFf "$history" |
                shuf -n 1
        } || true
    )"

    if [[ -z "$url" ]]; then
        url="$(jq -r '.data[].path' <<< "$json" | shuf -n 1)"
    fi

    if [[ -z "$url" ]]; then
        notify "Wallhaven returned no One Piece wallpaper"
        exit 1
    fi

    printf '%s\n' "$url" >> "$history"
    tail -n 200 "$history" > "$history.tmp"
    mv "$history.tmp" "$history"

    file="$(download_to_wallpapers "$url" "wallhaven_one_piece")"
    apply_wallpaper "$file"
}

require_online_tools() {
    local missing=()

    command -v curl >/dev/null 2>&1 || missing+=("curl")
    command -v jq >/dev/null 2>&1 || missing+=("jq")

    if (( ${#missing[@]} > 0 )); then
        notify "Missing required tools: ${missing[*]}"
        exit 1
    fi
}
