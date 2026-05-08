# march Overview Spec

Goal: make bare `Super` open a march-native window overview.

## Direction

- Bare `Super` should not open fuzzel or the app launcher.
- `Super + Space` remains the rofi command palette.
- Bare `Super` opens the overview on key release, not key press.
- If another Super combo is used, the release action is interrupted so normal
  shortcuts do not also open overview.

## Behavior

Pressing and releasing `Super` opens a visual window/workspace overview similar
in spirit to End-4:

- Show workspaces.
- Show open windows as draggable previews.
- Allow moving windows between workspaces by drag and drop.
- Allow focusing a window by selecting its preview.
- Allow middle-clicking a window preview to close it.
- Limit normal workspaces to 10.
- Keep the interaction fast and keyboard-friendly.
- Avoid adding a dock.

## Backend

- Keep the implementation self-contained in march.
- Reuse the End-4 logic pattern, not the End-4 runtime files.
- Track Hyprland state with `hyprctl -j clients`, `monitors`, `workspaces`,
  and `activeworkspace`.
- Move windows with `hyprctl dispatch movetoworkspacesilent <workspace>, address:<address>`.
- Focus windows with `hyprctl dispatch focuswindow address:<address>`.
