# macrch Theme

This is the fixed visual direction for macrch before dynamic wallpaper theming
is added.

## Direction

- Dark glass.
- Cold blue with soft purple.
- Anime, dark, and minimal wallpapers should fit naturally.
- Close to Catppuccin Macchiato, but darker and more glass-heavy.
- Main feel: Arch-native macOS hybrid, not a literal macOS clone.

## Color Tokens

```css
:root {
  /* Base */
  --bg: #0B0D12;
  --bg-soft: #11141B;
  --surface: rgba(24, 27, 36, 0.52);
  --surface-strong: rgba(30, 34, 45, 0.68);

  /* Glass */
  --glass-bg: rgba(18, 21, 28, 0.46);
  --glass-border: rgba(255, 255, 255, 0.14);
  --glass-highlight: rgba(255, 255, 255, 0.22);
  --glass-shadow: rgba(0, 0, 0, 0.35);

  /* Text */
  --text: #F2F4F8;
  --text-muted: #A8B0C0;
  --text-dim: #6F7787;

  /* Accent */
  --accent: #8AADF4;
  --accent-2: #C6A0F6;
  --accent-3: #91D7E3;

  /* State */
  --success: #A6DA95;
  --warning: #EED49F;
  --error: #ED8796;

  /* Bar */
  --bar-bg: rgba(17, 20, 28, 0.58);
  --bar-border: rgba(255, 255, 255, 0.13);
  --bar-active: rgba(138, 173, 244, 0.22);
  --bar-hover: rgba(255, 255, 255, 0.10);

  /* Terminal and shape */
  --kitty-opacity: 0.72;
  --blur-size: 8px;
  --rounding: 16px;
}
```

## Practical Palette

```text
Main background: #0B0D12
Glass bar:       rgba(17, 20, 28, 0.58)
Main text:       #F2F4F8
Muted text:      #A8B0C0
Blue accent:     #8AADF4
Purple accent:   #C6A0F6
Glass border:    rgba(255, 255, 255, 0.13)
```

## Fonts

UI font:

```text
Inter
```

UI fallback stack:

```text
Inter, "SF Pro Display", "Noto Sans", sans-serif
```

Terminal and code font:

```text
JetBrainsMono Nerd Font, monospace
```

Icon fonts:

```text
Symbols Nerd Font
Material Symbols Rounded
```

Use icon fonts for bar symbols, workspace app icons, Wi-Fi, battery, and volume
when a native icon source is not available.

## Component Targets

Bar:

- Height: 32px.
- Rounding: 16px.
- Background: `--bar-bg`.
- Border: `--bar-border`.
- Active workspace: `--bar-active`.
- Hover state: `--bar-hover`.

Glass surfaces:

- Background: `--glass-bg`.
- Border: `--glass-border`.
- Highlight: `--glass-highlight`.
- Shadow: `--glass-shadow`.

Terminal:

- Kitty opacity target: `0.72`.
- Terminal should remain readable while letting the wallpaper show through.

Hyprland:

- Blur size target: `8px`.
- Rounding target: `16px`.

## Dynamic Theme Rule

When matugen or pywal is added, generated colors can replace accent and surface
tokens, but these constants should remain the fallback baseline. Generated
themes must preserve:

- Dark glass base.
- Readable text contrast.
- Cold blue or purple accent bias.
- Transparent kitty background.
- 32px top bar with 16px rounding.
