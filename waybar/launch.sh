#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Waybar Launcher
# Launches Waybar with screen-size-appropriate styling
# ═══════════════════════════════════════════════════════════════

CONFIG_DIR="$HOME/.config/waybar"

# Get screen width
get_width() {
    if command -v hyprctl &> /dev/null; then
        hyprctl monitors -j 2>/dev/null | jq -r '.[0].width' 2>/dev/null || echo "1920"
    else
        echo "1920"
    fi
}

WIDTH=$(get_width)

# Set sizes based on resolution
if [ "$WIDTH" -ge 3840 ]; then
    # 4K
    FONT_SIZE="22px"
    BAR_WIDTH="56"
    ICON_SIZE="24px"
    MODULE_PADDING="16"
    BORDER_RADIUS="12"
elif [ "$WIDTH" -ge 2560 ]; then
    # 1440p
    FONT_SIZE="16px"
    BAR_WIDTH="44"
    ICON_SIZE="18px"
    MODULE_PADDING="12"
    BORDER_RADIUS="10"
elif [ "$WIDTH" -ge 1920 ]; then
    # 1080p
    FONT_SIZE="12px"
    BAR_WIDTH="32"
    ICON_SIZE="14px"
    MODULE_PADDING="8"
    BORDER_RADIUS="6"
else
    # Small screens
    FONT_SIZE="10px"
    BAR_WIDTH="26"
    ICON_SIZE="12px"
    MODULE_PADDING="6"
    BORDER_RADIUS="4"
fi

# Generate dynamic style
cat > /tmp/waybar-dynamic.css << EOF
/* Auto-generated based on screen: ${WIDTH}px */
* {
    font-size: ${FONT_SIZE};
}

window#waybar {
    border-radius: ${BORDER_RADIUS}px;
}

#workspaces button,
#clock,
#cpu,
#memory,
#backlight,
#pulseaudio,
#mpris,
#network,
#battery,
#tray {
    font-size: ${ICON_SIZE};
    padding: ${MODULE_PADDING}px 4px;
}
EOF

# Kill existing waybar
pkill waybar 2>/dev/null
sleep 0.2

# Update config with correct width
TMP_CONFIG="/tmp/waybar-config.json"
if [ -f "$CONFIG_DIR/config" ]; then
    jq --argjson w "$BAR_WIDTH" '.width = $w' "$CONFIG_DIR/config" > "$TMP_CONFIG" 2>/dev/null || cp "$CONFIG_DIR/config" "$TMP_CONFIG"
else
    cp "$CONFIG_DIR/config" "$TMP_CONFIG"
fi

# Launch waybar with both style files
waybar -c "$TMP_CONFIG" -s "$CONFIG_DIR/style.css" &

# Also apply dynamic overrides after a short delay
sleep 0.5

