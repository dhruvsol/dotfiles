#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# awww Wallpaper Starter - Sakura Night
# https://codeberg.org/LGFae/awww
# ═══════════════════════════════════════════════════════════════

WALLPAPER="$HOME/.config/hypr/bg.jpeg"

# Wait for Hyprland to be ready
sleep 2

# Check if wallpaper exists
if [[ ! -f "$WALLPAPER" ]]; then
    echo "Wallpaper not found: $WALLPAPER"
    exit 1
fi

# Start the daemon
awww-daemon &
sleep 1

# Set wallpaper with a nice transition
awww img "$WALLPAPER" \
    --transition-type grow \
    --transition-pos center \
    --transition-duration 1

echo "Wallpaper set!"

