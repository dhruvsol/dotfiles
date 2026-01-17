#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# Hyprpaper Starter - starts hyprpaper and keeps it running
# ═══════════════════════════════════════════════════════════════

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

# Kill existing instance if any
killall hyprpaper 2>/dev/null
sleep 1

# Start hyprpaper - exec replaces this script with hyprpaper
# so hyprpaper keeps running after the script "ends"
echo "Starting hyprpaper..."
exec hyprpaper
