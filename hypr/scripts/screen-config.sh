#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Screen Size Configuration
# Detects screen resolution and sets appropriate sizes
# ═══════════════════════════════════════════════════════════════

# Get primary monitor resolution
get_resolution() {
    if command -v hyprctl &> /dev/null; then
        hyprctl monitors -j | jq -r '.[0].width'
    elif command -v xrandr &> /dev/null; then
        xrandr | grep -w connected | head -1 | grep -oP '\d+x\d+' | cut -d'x' -f1
    else
        echo "1920"  # Default fallback
    fi
}

WIDTH=$(get_resolution)

# Determine screen category
if [ "$WIDTH" -ge 3840 ]; then
    SCREEN_SIZE="4k"
    FONT_SIZE=14
    WAYBAR_WIDTH=42
    ALACRITTY_FONT=12
    PADDING=20
elif [ "$WIDTH" -ge 2560 ]; then
    SCREEN_SIZE="1440p"
    FONT_SIZE=11
    WAYBAR_WIDTH=34
    ALACRITTY_FONT=10
    PADDING=16
elif [ "$WIDTH" -ge 1920 ]; then
    SCREEN_SIZE="1080p"
    FONT_SIZE=10
    WAYBAR_WIDTH=28
    ALACRITTY_FONT=9
    PADDING=14
else
    SCREEN_SIZE="small"
    FONT_SIZE=9
    WAYBAR_WIDTH=24
    ALACRITTY_FONT=8
    PADDING=10
fi

# Export for other scripts
export SCREEN_SIZE
export FONT_SIZE
export WAYBAR_WIDTH
export ALACRITTY_FONT
export PADDING

# Write to temp file for other apps to read
cat > /tmp/sakura-screen-config << EOF
SCREEN_SIZE=$SCREEN_SIZE
FONT_SIZE=$FONT_SIZE
WAYBAR_WIDTH=$WAYBAR_WIDTH
ALACRITTY_FONT=$ALACRITTY_FONT
PADDING=$PADDING
EOF

echo "Screen: ${WIDTH}px → $SCREEN_SIZE (font: $FONT_SIZE, waybar: ${WAYBAR_WIDTH}px)"

