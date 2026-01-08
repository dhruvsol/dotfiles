#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# Hyprpaper Starter - starts hyprpaper and sets wallpaper
# ═══════════════════════════════════════════════════════════════

WALLPAPER="$HOME/.config/hypr/bg.jpeg"

# Wait for Hyprland to be ready
sleep 2

# Check if wallpaper exists
if [[ ! -f "$WALLPAPER" ]]; then
    echo "Error: Wallpaper not found at $WALLPAPER"
    exit 1
fi

# Kill existing instance if any
killall hyprpaper 2>/dev/null
sleep 1

# Start hyprpaper in background
echo "Starting hyprpaper..."
hyprpaper &
HYPRPAPER_PID=$!

# Wait for hyprpaper to initialize
sleep 3

# Preload and set wallpaper via hyprctl
echo "Setting wallpaper..."
hyprctl hyprpaper preload "$WALLPAPER"
sleep 1

# Get all monitors and set wallpaper on each
for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
    echo "Setting wallpaper on $monitor"
    hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER"
done

echo "Wallpaper set successfully!"

# Keep the script running to maintain the service
wait $HYPRPAPER_PID
