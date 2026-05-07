# Codex Instructions for macrch

You are working on macrch, a custom Arch Linux rice.

Rules:

- Do not use End-4 code directly.
- Do not depend on End-4 runtime files, `~/.config/illogical-impulse`, or
  `~/.config/quickshell/ii`.
- Use Hyprland + Quickshell.
- Keep QML modular.
- Prefer small components.
- Follow specs in `./specs`.
- Implement phase tasks from `./tasks`.
- Do not add a dock.
- Do not create a heavy dashboard unless requested.
- Prioritize a working minimal top bar first.

Current goal:

Build a minimal Quickshell top bar with glassmorphism.
