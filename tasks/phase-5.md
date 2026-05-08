# Phase 5 Tasks

Goal: Add wallpaper management and dynamic theme generation.

## Tasks

1. Start with local wallpapers only.
2. Add a wallpaper apply command.
3. Generate colors from the selected wallpaper with matugen and/or pywal.
4. Write generated colors into march-owned theme files.
5. Apply generated colors to Quickshell.
6. Apply generated colors to rofi.
7. Apply generated colors to kitty.
8. Add online wallpaper support only after local wallpaper flow works.
9. Add lightweight current/previous wallpaper management before favorites.
10. Add real theme picker modes: dynamic, fallback, status.
11. Port End-4 O/K/W online wallpaper flow as march-owned scripts.

## Done When

- A local wallpaper can be selected and applied.
- `@ wallpaper picker` and `@ random wallpaper` work from the rofi palette.
- `@ current wallpaper`, `@ previous wallpaper`, and `@ open wallpaper folder` work from the rofi palette.
- `@ theme picker`, `@ theme dynamic`, `@ theme fallback`, and `@ theme status` work from the rofi palette.
- `@ online osu seasonal`, `@ online konachan safe`, and `@ online wallhaven onepiece` download and apply wallpapers without End-4 paths.
- Wallpaper display is owned by march through a Quickshell background layer, not End-4 or a required external daemon.
- Generated `march-colors.json` can override Quickshell colors.
- Generated `rofi-colors.rasi` can override rofi command palette/app launcher colors.
- Generated `kitty-colors.conf` can override kitty colors while keeping opacity/glass settings.
- Quickshell, rofi, and kitty can share the generated palette.
- The fallback theme still works if generation fails.
- No generated file writes into End-4 paths.
