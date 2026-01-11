#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Screenshot Tool
# ═══════════════════════════════════════════════════════════════

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="$SCREENSHOT_DIR/screenshot_$TIMESTAMP.png"

notify_success() {
    notify-send -i camera-photo "Screenshot" "$1" -h string:x-canonical-private-synchronous:screenshot
}

notify_error() {
    notify-send -i dialog-error "Screenshot" "$1" -h string:x-canonical-private-synchronous:screenshot
}

case "$1" in
    "full")
        # Full screen screenshot
        grim "$FILENAME" && notify_success "Full screen saved\n$FILENAME"
        ;;
    "area")
        # Select area
        grim -g "$(slurp)" "$FILENAME" && notify_success "Area saved\n$FILENAME"
        ;;
    "window")
        # Active window
        WINDOW=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$WINDOW" "$FILENAME" && notify_success "Window saved\n$FILENAME"
        ;;
    "full-clip")
        # Full screen to clipboard
        grim - | wl-copy && notify_success "Full screen copied to clipboard"
        ;;
    "area-clip")
        # Select area to clipboard
        grim -g "$(slurp)" - | wl-copy && notify_success "Area copied to clipboard"
        ;;
    "window-clip")
        # Active window to clipboard
        WINDOW=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$WINDOW" - | wl-copy && notify_success "Window copied to clipboard"
        ;;
    "edit")
        # Select area and edit with swappy
        grim -g "$(slurp)" - | swappy -f - -o "$FILENAME" && notify_success "Edited screenshot saved\n$FILENAME"
        ;;
    *)
        echo "Usage: $0 {full|area|window|full-clip|area-clip|window-clip|edit}"
        exit 1
        ;;
esac

