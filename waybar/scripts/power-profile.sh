#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Power Profile Switcher
# ═══════════════════════════════════════════════════════════════

# Check if power-profiles-daemon is available
if ! command -v powerprofilesctl &> /dev/null; then
    echo '{"text": "󱐋", "tooltip": "power-profiles-daemon not installed", "class": "unavailable"}'
    exit 0
fi

# Get current profile
get_profile() {
    powerprofilesctl get
}

# Get icon and class based on profile
get_status() {
    local profile=$(get_profile)
    local icon=""
    local class=""
    local tooltip=""
    
    case "$profile" in
        "performance")
            icon="󰓅"
            class="performance"
            tooltip="Performance Mode\n⚡ Maximum performance\n🔋 Higher power usage"
            ;;
        "balanced")
            icon="󰾅"
            class="balanced"
            tooltip="Balanced Mode\n⚖️ Balance of power and performance"
            ;;
        "power-saver")
            icon="󰌪"
            class="power-saver"
            tooltip="Power Saver Mode\n🔋 Maximum battery life\n🐢 Reduced performance"
            ;;
        *)
            icon="󱐋"
            class="unknown"
            tooltip="Unknown profile: $profile"
            ;;
    esac
    
    echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\", \"class\": \"$class\"}"
}

# Cycle through profiles
cycle_profile() {
    local current=$(get_profile)
    local next=""
    
    case "$current" in
        "performance")
            next="balanced"
            ;;
        "balanced")
            next="power-saver"
            ;;
        "power-saver")
            next="performance"
            ;;
        *)
            next="balanced"
            ;;
    esac
    
    powerprofilesctl set "$next"
    
    # Send notification
    local icon=""
    local name=""
    case "$next" in
        "performance")
            icon="󰓅"
            name="Performance"
            ;;
        "balanced")
            icon="󰾅"
            name="Balanced"
            ;;
        "power-saver")
            icon="󰌪"
            name="Power Saver"
            ;;
    esac
    
    notify-send -h string:x-canonical-private-synchronous:power-profile \
        -i battery \
        "Power Profile" \
        "$icon $name"
}

# Handle arguments
case "$1" in
    "cycle")
        cycle_profile
        ;;
    "set")
        if [[ -n "$2" ]]; then
            powerprofilesctl set "$2"
        fi
        ;;
    *)
        get_status
        ;;
esac

