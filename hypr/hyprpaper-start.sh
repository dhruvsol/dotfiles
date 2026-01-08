#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# Hyprpaper Starter - starts hyprpaper and sets wallpaper
# ═══════════════════════════════════════════════════════════════

WALLPAPER="$HOME/.config/hypr/bg.jpeg"

# Wait for Hyprland to be fully ready
sleep 3

# Check if wallpaper exists
if [[ ! -f "$WALLPAPER" ]]; then
    notify-send "Hyprpaper" "Wallpaper not found: $WALLPAPER"
    exit 1
fi

# Kill existing instance if any
killall hyprpaper 2>/dev/null
sleep 1

# Start hyprpaper in background
hyprpaper &
sleep 2



# Get all monitors and set wallpaper on each
if command -v jq &>/dev/null; then
    for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
        hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER" 2>/dev/null
    done
else
    # Fallback if jq not installed - try common monitor names
    hyprctl hyprpaper wallpaper "eDP-1,$WALLPAPER" 2>/dev/null
    hyprctl hyprpaper wallpaper "DP-1,$WALLPAPER" 2>/dev/null
    hyprctl hyprpaper wallpaper "HDMI-A-1,$WALLPAPER" 2>/dev/null
fi

echo "Hyprpaper started"
