#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# awww Wallpaper Starter - Sakura Night
# https://codeberg.org/LGFae/awww
# ═══════════════════════════════════════════════════════════════

WALLPAPER="$HOME/.config/hypr/bg.jpeg"
LOG="/tmp/awww-start.log"

exec &> "$LOG"
echo "=== awww Start $(date) ==="

# Wait for Hyprland to be ready
wait_for_hyprland() {
    local max_attempts=30
    local attempt=0
    
    while [[ $attempt -lt $max_attempts ]]; do
        if hyprctl monitors &>/dev/null; then
            echo "Hyprland ready after $attempt attempts"
            return 0
        fi
        sleep 1
        ((attempt++))
    done
    return 1
}

echo "Waiting for Hyprland..."
if ! wait_for_hyprland; then
    echo "ERROR: Hyprland not ready"
    exit 1
fi

# Extra wait for display to be fully initialized
sleep 3

# Check wallpaper
if [[ ! -f "$WALLPAPER" ]]; then
    echo "ERROR: Wallpaper not found: $WALLPAPER"
    exit 1
fi
echo "Wallpaper: $WALLPAPER"

# Kill any existing daemon
killall awww-daemon 2>/dev/null
sleep 1

# Start daemon in background and wait for it
echo "Starting awww-daemon..."
awww-daemon &
sleep 2

# Set wallpaper
echo "Setting wallpaper..."
awww img "$WALLPAPER" --transition-type grow --transition-pos center --transition-duration 1

echo "=== Done ==="

# Keep script alive to monitor daemon
wait
