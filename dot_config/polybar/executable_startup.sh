#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Seed current-colors.ini so polybar can launch before darkman's first
# transition fires. Darkman overwrites this file on each mode switch.
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/polybar"
mode="$(cat "${XDG_CONFIG_HOME:-$HOME/.config}/theme-mode" 2>/dev/null)"
case "$mode" in
    light|dark) ;;
    *) mode=dark ;;
esac
cp "$config_dir/colors-$mode.ini" "$config_dir/current-colors.ini"

# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar meso 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
