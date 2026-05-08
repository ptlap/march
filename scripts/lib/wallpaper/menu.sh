wallpaper_menu() {
    local selected

    selected="$(
        printf '%s\n' \
            "local random" \
            "local picker" \
            "history previous" \
            "info current" \
            "info open folder" \
            "online osu seasonal" \
            "online konachan safe" \
            "online wallhaven onepiece" \
            "theme picker" \
            "theme status" |
            rofi -dmenu \
                -config "$palette_config" \
                -p "wall" \
                -mesg "local: files/random  history: previous  online: O/K/W  theme: colors"
    )" || exit 0

    case "$selected" in
        "local random")
            random_wallpaper
            ;;
        "local picker")
            pick_wallpaper
            ;;
        "history previous")
            previous_wallpaper
            ;;
        "info current")
            show_current_wallpaper
            ;;
        "info open folder")
            open_current_wallpaper_folder
            ;;
        "online osu seasonal")
            download_online_wallpaper osu
            ;;
        "online konachan safe")
            download_online_wallpaper konachan
            ;;
        "online wallhaven onepiece")
            download_online_wallpaper wallhaven-onepiece
            ;;
        "theme picker")
            theme_picker
            ;;
        "theme status")
            theme_status
            ;;
    esac
}
