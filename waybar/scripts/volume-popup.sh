#!/bin/bash
# Volume Slider Popup for Waybar
# Requires: yad, pactl

# Get current volume
get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%'
}

# Get mute status
get_mute() {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -oP 'yes|no'
}

# Set volume
set_volume() {
    pactl set-sink-volume @DEFAULT_SINK@ "$1%"
}

# Toggle mute
toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
}

CURRENT_VOL=$(get_volume)
MUTE_STATUS=$(get_mute)

# Check if yad is available
if command -v yad &> /dev/null; then
    # Use yad for slider popup
    NEW_VOL=$(yad --scale \
        --title="Volume" \
        --width=300 \
        --height=80 \
        --value="$CURRENT_VOL" \
        --min-value=0 \
        --max-value=100 \
        --step=5 \
        --print-partial \
        --hide-value \
        --vertical \
        --undecorated \
        --on-top \
        --skip-taskbar \
        --mouse \
        --close-on-unfocus \
        2>/dev/null)
    
    if [ -n "$NEW_VOL" ]; then
        set_volume "$NEW_VOL"
    fi

# Fallback to zenity
elif command -v zenity &> /dev/null; then
    NEW_VOL=$(zenity --scale \
        --title="Volume" \
        --text="Adjust volume:" \
        --value="$CURRENT_VOL" \
        --min-value=0 \
        --max-value=100 \
        --step=5 \
        2>/dev/null)
    
    if [ -n "$NEW_VOL" ]; then
        set_volume "$NEW_VOL"
    fi

# Fallback to rofi
elif command -v rofi &> /dev/null; then
    # Generate volume options
    OPTIONS=""
    for i in $(seq 0 5 100); do
        if [ "$i" -eq "$CURRENT_VOL" ] || [ "$((CURRENT_VOL / 5 * 5))" -eq "$i" ]; then
            OPTIONS="$OPTIONS$i% ◀\n"
        else
            OPTIONS="$OPTIONS$i%\n"
        fi
    done
    
    SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -p "Volume" -selected-row $((CURRENT_VOL / 5)) -theme-str 'window {width: 150px;}')
    
    if [ -n "$SELECTED" ]; then
        NEW_VOL=$(echo "$SELECTED" | tr -d '%◀ ')
        set_volume "$NEW_VOL"
    fi

else
    # No GUI available, just open pavucontrol
    pavucontrol &
fi

