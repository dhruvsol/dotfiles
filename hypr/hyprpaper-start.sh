#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# Hyprpaper Starter - ensures hyprpaper is running
# ═══════════════════════════════════════════════════════════════

CONFIG="$HOME/.config/hypr/hyprpaper.conf"
WALLPAPER="$HOME/.config/hypr/bg.jpeg"

# Wait for Hyprland to be ready
sleep 2

# Check if config exists
if [[ ! -f "$CONFIG" ]]; then
    echo "Error: hyprpaper.conf not found at $CONFIG"
    exit 1
fi

# Check if wallpaper exists
if [[ ! -f "$WALLPAPER" ]]; then
    echo "Error: Wallpaper not found at $WALLPAPER"
    exit 1
fi

# Kill existing instance if any
killall hyprpaper 2>/dev/null

# Start hyprpaper
echo "Starting hyprpaper..."
exec hyprpaper

