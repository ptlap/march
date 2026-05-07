# march Launcher Spec

Launcher: rofi-wayland

## Style

- Spotlight + command palette hybrid.
- Opened with Super + Space.
- Centered on screen.
- Rounded.
- Translucent.
- Keyboard-first.

## Use Cases

- Launch apps.
- Run commands.
- Change wallpaper.
- Switch theme.
- Trigger scripts.

## Prefixes

```text
> apps / launch app
! system actions
@ wallpaper / theme
# workspace / window
? help / docs / keybinds
```

The command palette should show a small footer so the prefix meanings are easy
to remember:

```text
> apps  ! system  @ theme/wallpaper  # workspace  ? help
```

Bare `Super` is not part of the launcher. It is reserved for the future
window/workspace overview described in `specs/overview.md`.
