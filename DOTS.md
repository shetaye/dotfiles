# DOTS — desktop environment cheat sheet

This is a custom DE built from individual pieces. When you forget "wait, what
do I use for X" — look here. Configs live under
`~/.local/share/chezmoi/dot_config/`; helper scripts under
`~/.local/share/chezmoi/dot_local/bin/`.

## TL;DR — component map

| Role                  | X11 (i3)            | Wayland (sway)       |
| --------------------- | ------------------- | -------------------- |
| Window manager        | **i3**              | **sway**             |
| Compositor            | **picom**           | (built into sway)    |
| Status bar            | **polybar**         | **waybar**           |
| App launcher          | **rofi**            | **wofi**             |
| Notifications         | **dunst**           | **mako**             |
| Screen locker         | **i3lock**          | **swaylock**         |
| Idle / lock-on-sleep  | **xss-lock**        | xss-lock + swaylock  |
| Wallpaper             | **feh** (via script)| sway `output … background` |
| Display setup         | `~/.local/bin/x11-display-setup` + xrandr | `output …` in `sway/config.tmpl` |
| Screenshot menu       | `~/.local/bin/screenshot-x11` (maim + xclip + rofi) | `~/.local/bin/screenshot` (grim + slurp + wl-copy + wofi) |
| Password menu         | `~/.local/bin/passmenu-x11` → pass + xdotool | `sway/op.sh` → 1Password CLI + wl-copy |
| Terminal              | **alacritty** (primary), kitty (alt) | same |
| File manager          | **nnn** — launch with `n` (function in bashrc) | same |
| Editor                | **emacs** (daemon + emacsclient), nvim as `$EDITOR` for CLI tools | same |
| Mail                  | **Betterbird** — workspace on F10 | same |
| Chat                  | **Discord** F9, **Signal** F12 | same |
| Passwords (GUI)       | **1Password** F11 | same |
| Light/dark scheduler  | **darkman** (geoclue → sunrise/sunset) | same |
| Network               | **NetworkManager** + `nm-applet` tray icon | same |
| Bluetooth             | **`bluetui`** (TUI) on top of `bluetooth.service` / bluez | same |
| Audio                 | **PipeWire** + `pipewire-pulse` + `wireplumber`; control with `pactl` | same |
| Brightness            | **`brightnessctl`** | same |
| Time / NTP            | **chronyd** (`systemctl status chronyd`) | same |
| GPG / SSH agent       | **gpg-agent** (used as SSH agent on desktop) | same |
| VPN                   | tailscale (`tailscaled.service`), `wg-quick@wg0` | same |
| Dotfile mgmt          | **chezmoi** (source: `~/.local/share/chezmoi`) | same |

## Startup chain

X11 (the daily driver — `~/.xinitrc` ends in `exec i3`):

```
startx → xinitrc → i3
  ├─ dex --autostart                # XDG autostart .desktop files
  ├─ ~/.local/bin/x11-display-setup # xrandr + wallpaper via feh
  ├─ xss-lock -- i3lock --nofork    # lock on sleep / idle
  ├─ nm-applet                      # NM tray icon
  ├─ emacs --daemon
  ├─ picom --config ~/.config/picom/picom.conf
  ├─ dunst                          # notification daemon
  └─ polybar (via ~/.config/polybar/startup.sh)
```

Sway mirrors this with mako instead of dunst and the compositor folded in.

`darkman` runs out-of-band as a systemd user unit (`systemctl --user enable
--now darkman.service`), not from the WM config — so the same scheduler
serves X11 and Wayland sessions and survives WM restarts.

## Keybinds (mod = Super)

Same set in i3 and sway except where noted.

### Windows / workspaces
- `mod+Return` — terminal (alacritty)
- `mod+d` — app launcher (rofi / wofi)
- `mod+Shift+q` — kill window
- `mod+f` — fullscreen
- `mod+h` / `mod+v` — split horizontal / vertical
- `mod+s` — stacking; `mod+e` — toggle split
- `mod+Shift+space` — float toggle; `mod+space` — focus float/tile toggle
- `mod+j k l ;` — focus left/down/up/right (vi-ish); arrows also work
- `mod+Shift+<dir>` — move window
- `mod+1`…`mod+0` — switch workspace; `mod+Shift+<n>` — move window to workspace
- `mod+r` — resize mode; `mod+w` — window-to-output mode (h/j/k/l)
- `mod+a` — focus parent
- `mod+g` / `mod+Shift+g` — set horizontal gaps to 1280 / 0 (ultrawide reading mode)

### Apps / system
- `mod+\` (backslash) — open `~/org/motd.org` in emacs
- `mod+o` — passmenu (X11 only; sway uses 1Password via op.sh)
- `mod+p` — screenshot menu
- `mod+Control+l` — lock
- `mod+Shift+t` — `darkman toggle`
- `mod+Shift+c` — reload config; `mod+Shift+r` — restart WM
- `mod+Shift+e` — exit prompt

### Hardware keys
- `XF86AudioRaiseVolume` / `…Lower` / `…Mute` — `pactl`
- `XF86AudioMicMute` — toggle source mute
- `XF86MonBrightnessUp` / `…Down` — `brightnessctl set ±10%`

### Dedicated app workspaces (F9–F12)
Each key jumps to the app's workspace and launches it if not running. Some
weird XF86 keys are mapped because the ThinkPad/Logi keyboards emit them on
the dedicated F-row buttons.

- `F9`  / `Print`                                  — Discord
- `F10` / `XF86SelectiveScreenshot` / `…PickupPhone` — Betterbird
- `F11` / `XF86LinkPhone`        / `…HangupPhone`   — 1Password
- `F12` / `XF86Favorites`                          — Signal

## Theme

darkman flips light/dark based on geoclue sunrise/sundown; `mod+Shift+t`
overrides it. It exposes the mode via the XDG color-scheme portal, and
per-app transition scripts live under `~/.local/share/darkman/` (kept in
chezmoi as `dot_local/share/darkman/`).

### Dark palette (primary)

```
bg        #030102   (near-black, slight magenta cast)
darkgray  #1F181B
gray      #473E42
red       #FF7358   (accent — coral)
yellow    #8380B9   (lavender, used as 'yellow' slot)
blue      #8380B9
purple    #FFD8FF   (pale pink)
green     #FFD8FF
aqua      #FF7358
white     #FFD8FF
```

The rofi/wofi/mako/dunst dark theme uses a different palette (deep
indigo `#0d0e1c`, `#1d2235`, `#2a2b42`, border `#61647a`, text `#ffffff`)
— it predates the coral/lavender bar palette and hasn't been unified.

### Light palette

Modus-operandi-ish:

```
bg        #fbf7f0
darkgray  #efe9dd
gray      #9f9690
red       #d00000
blue/yel  #0031a9
purple    #721045
aqua      #005e8b
fg        #000000
```

### Where each app picks up the theme
- alacritty: imports `~/.config/alacritty/current-theme.toml` →
  symlinked by darkman to `modus-vivendi.toml` / `modus-operandi.toml`.
- kitty: `current-theme.conf` swapped by darkman.
- polybar: `current-colors.ini` symlink → `colors-dark.ini` / `colors-light.ini`.
- rofi/wofi/mako/dunst: each has `-dark` / `-light` variants swapped by darkman.
- emacs: listens to the XDG color-scheme portal (`darkman: portal: true`).

## Fonts

- **Terminess Nerd Font Mono** — primary monospace. Used by alacritty, polybar
  main slot, mako/dunst, i3/sway bar font (`size 13` in WM, `size 9` in
  alacritty, `size 12` in notifications).
- **BerkeleyMono Nerd Font Mono** — used by kitty, rofi, wofi, swaylock, and
  the `lock-note` image generator.
- **Mononoki Nerd Font** — polybar fallback.
- Special rule: `dot_config/fontconfig/conf.d/10-tamzen-prefer-bdf.conf`
  forces TamzenForPowerline to the BDF bitmaps (the AUR TTF aliases badly).

## How do I…

- **…use bluetooth?** → `bluetui` in a terminal. The daemon is
  `bluetooth.service` (bluez).
- **…check the time daemon?** → `systemctl status chronyd`.
- **…browse files?** → `n` in a shell (it's the nnn wrapper from bashrc;
  cd-on-quit is wired up via `NNN_TMPFILE`).
- **…connect to wifi?** → click `nm-applet` in the tray, or `nmtui` in a
  shell. (`nmcli` if scripted.)
- **…change audio sink / volume?** → wheel-click the polybar/waybar volume
  module, or `pactl` / `pavucontrol`. The underlying server is PipeWire
  (with `pipewire-pulse` for PA compatibility).
- **…take a screenshot?** → `mod+p` opens the screenshot menu. The X11
  version uses maim + xclip; the Wayland one uses grim + slurp + wl-copy.
  Files land in `~/media/pictures/screenshots/`.
- **…grab a password?** → `mod+o` for `pass` (X11). On sway, run the
  `op.sh` script (1Password CLI + wofi).
- **…lock with a note for someone?** → run `lock-note` in a shell; it
  prompts for text via rofi, bakes it onto the wallpaper with ImageMagick,
  and locks with i3lock.
- **…change resolution / re-detect displays?** → re-run
  `~/.local/bin/x11-display-setup` (X11) or `swaymsg reload` (sway). Sway
  output config is templated by host (`enkidu` gets 120 Hz, others 60).
- **…toggle dark mode now?** → `mod+Shift+t` or `darkman toggle`.
- **…edit a dotfile?** → edit it in `~/.local/share/chezmoi/`, then
  `chezmoi apply`. `chezmoi edit <path>` does both.

## Hosts

- **enkidu** — desktop, 5120×1440 @ 120 Hz ultrawide(s).
- Laptops — eDP-1 @ 1920×1200/1080, clamshell disables eDP via
  `bindswitch lid:on/off` (sway) or by checking
  `/proc/acpi/button/lid/LID0/state` in `x11-display-setup`.

The chezmoi profile (`desktop` vs `remote`) is set at `chezmoi init` time
and stored in `~/.config/chezmoi/chezmoi.toml`. This file is gated to
`desktop` only — `remote` boxes won't see it.
