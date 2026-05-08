# Kitty Theme Picker Plan

Goal: allow both automatic and manual kitty theme selection without depending on
End-4 helpers.

## Static Files

- `kitty/kitty.conf`: handwritten main config.
- `kitty/themes/march-glass.conf`: fallback theme.
- `kitty/generated/current.conf`: future generated theme output.

## Manual Flow

1. List theme files under `kitty/themes/`.
2. Pick a theme from rofi command palette.
3. Write or symlink selected theme to `kitty/generated/current.conf`.
4. Reload or reopen kitty.

## Automatic Flow

1. Wallpaper changes.
2. matugen and/or pywal generates a palette.
3. march writes kitty colors into `kitty/generated/current.conf`.
4. Kitty config includes the generated file when it exists.

## Rule

Generated files must stay under `kitty/generated/` and must not write into
End-4 or illogical-impulse paths.
