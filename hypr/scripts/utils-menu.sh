#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Utils Menu
# ═══════════════════════════════════════════════════════════════

SCRIPTS_DIR="$HOME/.config/hypr/scripts"

# Menu options
declare -A OPTIONS=(
    ["󰹑  Screenshot - Full Screen"]="$SCRIPTS_DIR/screenshot.sh full"
    ["󰩭  Screenshot - Select Area"]="$SCRIPTS_DIR/screenshot.sh area"
    ["󱂬  Screenshot - Active Window"]="$SCRIPTS_DIR/screenshot.sh window"
    ["󰆏  Screenshot - Full to Clipboard"]="$SCRIPTS_DIR/screenshot.sh full-clip"
    ["󱇛  Screenshot - Area to Clipboard"]="$SCRIPTS_DIR/screenshot.sh area-clip"
    ["󰏫  Screenshot - Edit with Swappy"]="$SCRIPTS_DIR/screenshot.sh edit"
    ["─────────────────────────────"]=""
    ["󰅍  Clipboard - History"]="$SCRIPTS_DIR/clipboard.sh show"
    ["󰆴  Clipboard - Delete Item"]="$SCRIPTS_DIR/clipboard.sh delete"
    ["󰃢  Clipboard - Clear All"]="$SCRIPTS_DIR/clipboard.sh clear"
    ["─────────────────────────────"]=""
    ["󰈈  Color Picker"]="hyprpicker -a"
    ["󰍹  Screen Record (Start/Stop)"]="$SCRIPTS_DIR/screenrecord.sh toggle"
    ["─────────────────────────────"]=""
    ["󰖩  WiFi Settings"]="alacritty -e nmtui"
    ["󰕾  Audio Settings"]="pavucontrol"
    ["󰂯  Bluetooth Settings"]="blueman-manager"
    ["─────────────────────────────"]=""
    ["󰌌  Keyboard Shortcuts"]="$SCRIPTS_DIR/shortcuts.sh"
    ["󰐥  Power Menu"]="$SCRIPTS_DIR/power-menu.sh"
)

# Build menu (preserving order)
MENU_ITEMS=(
    "󰹑  Screenshot - Full Screen"
    "󰩭  Screenshot - Select Area"
    "󱂬  Screenshot - Active Window"
    "󰆏  Screenshot - Full to Clipboard"
    "󱇛  Screenshot - Area to Clipboard"
    "󰏫  Screenshot - Edit with Swappy"
    "─────────────────────────────"
    "󰅍  Clipboard - History"
    "󰆴  Clipboard - Delete Item"
    "󰃢  Clipboard - Clear All"
    "─────────────────────────────"
    "󰈈  Color Picker"
    "󰍹  Screen Record (Start/Stop)"
    "─────────────────────────────"
    "󰖩  WiFi Settings"
    "󰕾  Audio Settings"
    "󰂯  Bluetooth Settings"
    "─────────────────────────────"
    "󰌌  Keyboard Shortcuts"
    "󰐥  Power Menu"
)

# Show rofi menu
SELECTED=$(printf '%s\n' "${MENU_ITEMS[@]}" | rofi -dmenu \
    -p "󰣖 Utils" \
    -theme-str 'window {width: 400px;}' \
    -theme-str 'listview {lines: 20;}' \
    -theme-str 'element-text {horizontal-align: 0.0;}')

# Execute selected command
if [[ -n "$SELECTED" && "$SELECTED" != "─────────────────────────────" ]]; then
    CMD="${OPTIONS[$SELECTED]}"
    if [[ -n "$CMD" ]]; then
        eval "$CMD"
    fi
fi

