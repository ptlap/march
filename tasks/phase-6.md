# Phase 6 Tasks

Goal: Make march comfortable enough for daily use.

## Tasks

1. Add power/session controls.
2. Add brightness status and controls.
3. Add Bluetooth status.
4. Add CPU/RAM compact status.
5. Add optional music info in the center island.
6. Add notification support only after the bar, launcher, and theme flow are stable.
7. Implement bare `Super` as a window/workspace overview.
8. Support dragging windows between workspaces in the overview.
9. Add install documentation when the runtime path is settled.
10. Keep every feature reversible.

## Done When

- The desktop can be started with `qs -c march`.
- End-4 can still be restored with `pkill qs && qs -c ii`.
- Common daily actions work from keyboard-first flows.
- Bare `Super` opens the march overview, not fuzzel/search.
- The repo has clear docs for install, update, and rollback.
