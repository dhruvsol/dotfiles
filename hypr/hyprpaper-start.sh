#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# Hyprpaper Starter - starts hyprpaper and sets wallpaper
# ═══════════════════════════════════════════════════════════════

WALLPAPER="$HOME/.config/hypr/bg.jpeg"

# Wait for Hyprland to be fully ready
wait_for_hyprland() {
    local max_attempts=30
    local attempt=0
    
    while [[ $attempt -lt $max_attempts ]]; do
        if hyprctl monitors &>/dev/null; then
            return 0
        fi
        sleep 1
        ((attempt++))
    done
    return 1
}

echo "Waiting for Hyprland..."
if ! wait_for_hyprland; then
    echo "Hyprland not ready after 30 seconds"
    exit 1
fi

echo "Hyprland is ready"
sleep 2

# Check if wallpaper exists
if [[ ! -f "$WALLPAPER" ]]; then
    echo "Wallpaper not found: $WALLPAPER"
    exit 1
fi

# Kill existing instance if any
killall hyprpaper 2>/dev/null
sleep 1

# Start hyprpaper
echo "Starting hyprpaper..."
hyprpaper &

# Wait for hyprpaper to be ready (check if socket exists)
sleep 3

# Get monitor and set wallpaper
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name' 2>/dev/null || echo "eDP-1")
echo "Setting wallpaper on $MONITOR"
hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER" 2>/dev/null

echo "Done!"
