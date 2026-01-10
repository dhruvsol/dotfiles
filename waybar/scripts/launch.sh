#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Waybar Launcher
# Adjusts sizes based on screen resolution
# ═══════════════════════════════════════════════════════════════

CONFIG_DIR="$HOME/.config/waybar"
CONFIG_FILE="$CONFIG_DIR/config"
STYLE_FILE="$CONFIG_DIR/style.css"

# Kill existing waybar
pkill waybar 2>/dev/null
sleep 0.2

# Get primary monitor resolution
RESOLUTION=$(hyprctl monitors -j | jq -r '.[0].height')

# Set sizes based on resolution
if [[ "$RESOLUTION" -ge 2160 ]]; then
    # 4K (2160p+)
    BAR_WIDTH=48
    FONT_SIZE=14
    ICON_SIZE=16
    PADDING=12
    BORDER_RADIUS=10
elif [[ "$RESOLUTION" -ge 1440 ]]; then
    # 1440p
    BAR_WIDTH=38
    FONT_SIZE=12
    ICON_SIZE=14
    PADDING=10
    BORDER_RADIUS=8
elif [[ "$RESOLUTION" -ge 1080 ]]; then
    # 1080p
    BAR_WIDTH=32
    FONT_SIZE=11
    ICON_SIZE=12
    PADDING=8
    BORDER_RADIUS=6
else
    # 720p or smaller
    BAR_WIDTH=26
    FONT_SIZE=9
    ICON_SIZE=10
    PADDING=6
    BORDER_RADIUS=4
fi

# Export for CSS (waybar doesn't support env vars in CSS, so we generate it)
cat > "$CONFIG_DIR/style-dynamic.css" << EOF
/* ═══════════════════════════════════════════════════════════════
 * 🌸 Sakura Night - Dynamic Waybar Style
 * Auto-generated based on screen resolution: ${RESOLUTION}p
 * ═══════════════════════════════════════════════════════════════ */

/* Import base styles */
@import "style-base.css";

/* Resolution-specific overrides */
* {
  font-size: ${FONT_SIZE}px;
}

window#waybar {
  border-radius: ${BORDER_RADIUS}px;
}

#workspaces button {
  font-size: ${ICON_SIZE}px;
  padding: ${PADDING}px 4px;
  border-radius: ${BORDER_RADIUS}px;
}

#clock, #cpu, #memory, #backlight, #pulseaudio, #mpris, #network, #battery {
  font-size: ${ICON_SIZE}px;
  padding: ${PADDING}px 4px;
  margin: 4px 0;
  border-radius: ${BORDER_RADIUS}px;
}

#tray {
  padding: ${PADDING}px 4px;
}
EOF

# Update config width
sed -i "s/\"width\": [0-9]*/\"width\": $BAR_WIDTH/" "$CONFIG_FILE" 2>/dev/null || true

# Launch waybar with dynamic style
waybar -c "$CONFIG_FILE" -s "$CONFIG_DIR/style-dynamic.css" &

echo "Waybar launched: ${RESOLUTION}p mode (width: ${BAR_WIDTH}px, font: ${FONT_SIZE}px)"

