#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Clipboard Manager
# ═══════════════════════════════════════════════════════════════

case "$1" in
    "show")
        # Show clipboard history with rofi
        cliphist list | rofi -dmenu -p "󰅍 Clipboard" \
            -theme-str 'window {width: 600px;}' \
            -theme-str 'listview {lines: 15;}' | cliphist decode | wl-copy
        ;;
    "delete")
        # Delete item from history
        cliphist list | rofi -dmenu -p "󰆴 Delete" \
            -theme-str 'window {width: 600px;}' \
            -theme-str 'listview {lines: 15;}' | cliphist delete
        ;;
    "clear")
        # Clear all history
        cliphist wipe
        notify-send -i edit-clear "Clipboard" "History cleared"
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

