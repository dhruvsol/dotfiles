#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Clipboard Manager
# ═══════════════════════════════════════════════════════════════

# Check if cliphist is installed
if ! command -v cliphist &> /dev/null; then
    notify-send -u critical "Clipboard" "cliphist not installed!\nRun: sudo pacman -S cliphist"
    exit 1
fi

# Check if clipboard watcher is running
if ! pgrep -f "wl-paste.*cliphist" &> /dev/null; then
    # Start the watchers
    wl-paste --type text --watch cliphist store &
    wl-paste --type image --watch cliphist store &
    sleep 0.5
fi

case "$1" in
    "show")
        # Check if history is empty
        if [[ -z "$(cliphist list)" ]]; then
            notify-send "Clipboard" "History is empty\nCopy something first!"
            exit 0
        fi
        
        # Show clipboard history with rofi
        SELECTED=$(cliphist list | rofi -dmenu -p "󰅍 Clipboard" \
            -theme-str 'window {width: 600px;}' \
            -theme-str 'listview {lines: 15;}')
        
        if [[ -n "$SELECTED" ]]; then
            echo "$SELECTED" | cliphist decode | wl-copy
            notify-send "Clipboard" "Copied to clipboard"
        fi
        ;;
    "delete")
        # Delete item from history
        SELECTED=$(cliphist list | rofi -dmenu -p "󰆴 Delete" \
            -theme-str 'window {width: 600px;}' \
            -theme-str 'listview {lines: 15;}')
        
        if [[ -n "$SELECTED" ]]; then
            echo "$SELECTED" | cliphist delete
            notify-send "Clipboard" "Item deleted"
        fi
        ;;
    "clear")
        # Clear all history
        cliphist wipe
        notify-send "Clipboard" "History cleared"
        ;;
    "copy")
        # Copy from selection
        wl-paste
        ;;
    *)
        echo "Usage: $0 {show|delete|clear|copy}"
        exit 1
        ;;
esac

