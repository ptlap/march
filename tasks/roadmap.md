# march Roadmap

This roadmap keeps implementation ordered so march does not become a large
unfinished clone of End-4.

## Phase Order

1. `phase-1.md`: minimal Quickshell top bar.
2. `phase-2.md`: visual polish from screenshots.
3. `phase-3.md`: rofi-wayland launcher.
4. `phase-4.md`: kitty transparency and theme.
5. `phase-5.md`: wallpaper and dynamic colors.
6. `phase-6.md`: daily desktop controls.

## Working Rules

- Finish and commit one phase before expanding the next one.
- Do not add a dock.
- Do not depend on End-4 runtime paths.
- Prefer direct, keyboard-first tools.
- Keep screenshots local; do not commit image files from `screenshots/`.
- Keep rollback simple: `pkill qs && qs -c ii`.
