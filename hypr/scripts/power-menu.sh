#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Power Menu
# ═══════════════════════════════════════════════════════════════

# Options
SHUTDOWN="󰐥  Shutdown"
REBOOT="󰜉  Reboot"
SLEEP="󰤄  Sleep"
LOCK="󰌾  Lock"
LOGOUT="󰍃  Logout"
CANCEL="󰜺  Cancel"

# Rofi command
rofi_cmd() {
    rofi -dmenu \
        -p "Power" \
        -mesg "Select an action" \
        -theme-str 'window {width: 300px;}' \
        -theme-str 'listview {lines: 6;}' \
        -theme-str 'element-text {horizontal-align: 0.0;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}'
}

# Confirmation dialog
confirm_cmd() {
    rofi -dmenu \
        -p "Confirm" \
        -mesg "Are you sure?" \
        -theme-str 'window {width: 200px;}' \
        -theme-str 'listview {lines: 2;}'
}

# Ask for confirmation
confirm_action() {
    echo -e "Yes\nNo" | confirm_cmd
}

# Main menu
chosen=$(printf "%s\n%s\n%s\n%s\n%s\n%s" \
    "$SHUTDOWN" \
    "$REBOOT" \
    "$SLEEP" \
    "$LOCK" \
    "$LOGOUT" \
    "$CANCEL" | rofi_cmd)

case "$chosen" in
    "$SHUTDOWN")
        confirm=$(confirm_action)
        if [[ "$confirm" == "Yes" ]]; then
            systemctl poweroff
        fi
        ;;
    "$REBOOT")
        confirm=$(confirm_action)
        if [[ "$confirm" == "Yes" ]]; then
            systemctl reboot
        fi
        ;;
    "$SLEEP")
        systemctl suspend
        ;;
    "$LOCK")
        # Try different lock commands
        if command -v hyprlock &> /dev/null; then
            hyprlock
        elif command -v swaylock &> /dev/null; then
            swaylock -f -c 1a1b26
        elif command -v waylock &> /dev/null; then
            waylock
        else
            notify-send "Lock" "No lock program found"
        fi
        ;;
    "$LOGOUT")
        confirm=$(confirm_action)
        if [[ "$confirm" == "Yes" ]]; then
            hyprctl dispatch exit
        fi
        ;;
    "$CANCEL"|*)
        exit 0
        ;;
esac

