#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# Sakura Night - Shortcuts Menu
# Shows keyboard shortcuts in a rofi menu
# ═══════════════════════════════════════════════════════════════

SHORTCUTS_FILE="$HOME/.config/hypr/shortcuts.txt"

# Check if file exists
if [[ ! -f "$SHORTCUTS_FILE" ]]; then
    notify-send "Shortcuts" "shortcuts.txt not found!" -u critical
    exit 1
fi

# Parse and display shortcuts
# Filter out comments starting with # (but keep section headers)
# Format: "Shortcut    Description"

cat "$SHORTCUTS_FILE" | \
    grep -v "^#.*═" | \
    grep -v "^$" | \
    sed 's/^# ── /━━ /g' | \
    sed 's/ ─.*//g' | \
    rofi -dmenu \
        -p "⌨ Shortcuts" \
        -theme-str 'window {width: 500px; height: 600px;}' \
        -theme-str 'listview {lines: 20;}' \
        -i \
        -no-custom \
    > /dev/null

