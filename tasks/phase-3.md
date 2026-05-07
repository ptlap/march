# Phase 3 Tasks

Goal: Add the keyboard-first launcher with rofi-wayland.

## Tasks

1. Create a rofi-wayland config for march.
2. Style rofi as a Spotlight + command palette hybrid.
3. Use the march glass colors from `specs/ui-theme.md`.
4. Add a centered launcher layout.
5. Bind launcher target to Super + Space in the march Hyprland config.
6. Make Super + Space a march command palette, not a duplicate of Super.
7. Keep app launching available from the palette.
8. Keep launcher config independent from End-4.
9. Provide a fuzzel fallback while rofi-wayland is not installed.

## Done When

- Super + Space opens rofi.
- If rofi-wayland is not installed, Super + Space opens the fuzzel fallback.
- App search is fast and keyboard-first.
- Rofi visually matches the bar.
- No End-4 rofi config is required.
