# macrch Blueprint

macrch is a standalone Arch Linux desktop rice built from scratch with
Hyprland and Quickshell. End-4 is only a reference for ideas and fallback, not a
runtime dependency.

## Goal

- Build a separate config named `macrch`.
- Keep Hyprland as the window manager.
- Write the shell/bar in Quickshell.
- Use only a top bar, no dock.
- Keep the experience keyboard-first.
- Use blur, glassmorphism, transparent terminal, and wallpaper-driven colors.
- Avoid dependencies on `~/.config/illogical-impulse`, End-4 scripts, or End-4
  generated paths.

## Runtime Model

End-4 currently runs its shell with:

```sh
qs -c ii
```

macrch will run its shell with:

```sh
qs -c macrch
```

Development switching should work like this:

```sh
pkill qs
hyprctl reload
qs -c macrch
```

Permanent switching should happen only after the macrch shell is stable:

```ini
# old End-4 shell
# exec-once = qs -c ii

# macrch shell
exec-once = qs -c macrch
```

End-4 should remain installed as a fallback until macrch can fully replace the
daily desktop.

## Repository Layout

```text
macrch/
  docs/               planning and rules
  hypr/               Hyprland config layer for macrch
  quickshell/macrch/  Quickshell shell config loaded by `qs -c macrch`
  kitty/              kitty theme and transparency config
  rofi/               rofi-wayland launcher theme and scripts
  scripts/            start, install, restore, theme, wallpaper helpers
  themes/             generated or selected color outputs
  wallpapers/         local wallpaper library
```

This repo is the source of truth. Runtime files under `~/.config` should be
generated, copied, or symlinked from here later by install scripts.

## Desktop Shape

The first usable macrch desktop should include:

- A 32px top bar.
- 16px rounding.
- Three bar zones: left, center, right.
- Workspace indicators using numbers by default.
- Workspaces with open apps should be able to show app icons.
- Rofi-wayland app launcher.
- Kitty transparent enough to see the wallpaper.
- Wallpaper-driven colors through matugen and/or pywal.
- Manual kitty theme picker in addition to automatic theme generation.

## Bar Modules

Left zone:

- Launcher trigger.
- Workspace list.
- Optional active app title later, only if it stays compact.

Center zone:

- Clock or focused desktop context.
- Keep this minimal so the bar does not feel crowded.

Right zone:

- Network.
- Audio.
- Battery, when available.
- Tray or quick status modules later.
- Power/session menu later.

## Theme System

Theme generation should be owned by macrch.

Inputs:

- Current wallpaper.
- Optional selected color mode.
- Optional selected kitty theme.

Outputs:

- Quickshell color file.
- Hyprland color variables.
- Kitty theme file.
- Rofi theme file.

Preferred tools:

- `matugen` for Material-style palette generation.
- `pywal` for terminal-friendly palette generation.

The first implementation can be simple. It only needs to prove that one
wallpaper can generate colors for Quickshell, Hyprland, kitty, and rofi without
calling End-4 helpers.

## Wallpaper System

Wallpaper support should start with local files.

Later features:

- Online wallpaper download.
- Wallpaper picker.
- Automatic theme regeneration after wallpaper change.
- Restore last wallpaper on login.

## Switching and Recovery

Required scripts:

- `scripts/start-macrch.sh`: stop the current Quickshell process and start
  macrch.
- `scripts/restore-end4.sh`: stop macrch and start End-4 shell with `qs -c ii`.
- `scripts/install.sh`: install or link macrch config into `~/.config` later.

Never remove End-4 automatically. Switching should be reversible.

## First Milestone

The first milestone is not a full rice. It is a bootable shell foundation:

- `qs -c macrch` opens a visible top bar.
- Bar has left, center, and right zones.
- Hyprland blur and rounding are configured.
- Kitty can load a transparent theme.
- Rofi has a matching basic theme.
- Start and restore scripts work.

After this milestone, macrch can grow one module at a time.
