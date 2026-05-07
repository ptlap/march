# march Code Rules

These rules apply to all code and config added to march.

## Independence

- Do not import, source, execute, or depend on End-4 runtime files.
- Do not reference `~/.config/illogical-impulse`.
- Do not reference `~/.config/quickshell/ii`.
- Do not reference End-4 helper script paths.
- If an End-4 behavior is useful, reimplement it inside this repo.
- Keep march runnable even when End-4 is disabled.

## Scope

- Build only the top bar and supporting desktop tools.
- Do not add a dock.
- Do not add large click-first UI unless it supports a real workflow.
- Prefer keyboard-first flows and launcher-driven actions.
- Keep each change focused on one feature or module.

## Structure

- Put Hyprland config under `hypr/`.
- Put Quickshell code under `quickshell/march/`.
- Put kitty config under `kitty/`.
- Put rofi config under `rofi/`.
- Put shell helpers under `scripts/`.
- Put theme outputs/templates under `themes/`.
- Put local wallpapers under `wallpapers/`.

## Quickshell

- Keep the root shell small.
- Split bar modules into small QML files once they contain real logic.
- Use explicit module names and predictable paths.
- Do not hide process calls inside UI files when a script is clearer.
- Avoid fragile timing hacks unless there is no stable signal/API.
- Validate QML with `qmllint` when possible.

## Hyprland

- Keep march config as its own layer.
- Avoid editing the live End-4 Hyprland config directly.
- Prefer readable `.conf` files grouped by purpose.
- Validate with `Hyprland --verify-config` when possible.
- Keep startup commands reversible.

## Scripts

- Use Bash for helper scripts.
- Start scripts with:

```sh
#!/usr/bin/env bash
set -euo pipefail
```

- Scripts should print clear errors.
- Scripts must not delete End-4 files.
- Scripts must not assume the repo lives in a specific absolute path unless
  they derive it from their own location.
- Any destructive action needs an explicit flag or confirmation.

## Theme Code

- Theme generation must write march-owned files only.
- Keep generated files separate from templates where practical.
- A wallpaper change should be able to regenerate Quickshell, Hyprland, kitty,
  and rofi colors without End-4.
- Kitty transparency must stay configurable.

## Visual Rules

- Main aesthetic: Arch-native macOS hybrid.
- Use blur and glassmorphism, but keep text readable.
- Bar height target is 32px.
- Main rounding target is 16px.
- Avoid visual clutter in the bar.
- Do not make the desktop depend on one single color family only.
- Avoid oversized UI panels unless the feature needs them.

## Validation

Before treating a milestone as done, run the relevant checks:

```sh
Hyprland --verify-config -c hypr/march.conf
find quickshell/march -name '*.qml' -print -exec qmllint {} \;
```

Runtime checks:

```sh
pkill qs
qs -c march
```

If a runtime check fails because of the current session environment, record the
exact error instead of guessing.

## Commit Discipline

- Keep commits small.
- Commit working checkpoints after a visible milestone.
- Do not mix unrelated visual experiments with core runtime fixes.
- Keep rollback easy.
