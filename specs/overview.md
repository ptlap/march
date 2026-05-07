# march Overview Spec

Goal: reserve bare `Super` for a future window overview.

## Direction

- Bare `Super` should not open fuzzel or the app launcher.
- `Super + Space` remains the rofi command palette.
- Bare `Super` is reserved for a future overview mode.

## Future Behavior

When implemented, pressing `Super` should open a visual window/workspace
overview similar in spirit to End-4:

- Show workspaces.
- Show open windows as draggable previews.
- Allow moving windows between workspaces by drag and drop.
- Allow focusing a window by selecting its preview.
- Keep the interaction fast and keyboard-friendly.
- Avoid adding a dock.

## Temporary Behavior

Until the overview is implemented, bare `Super` should do nothing. This avoids
duplicating `Super + Space` and prevents the old fuzzel/search launcher from
appearing.
