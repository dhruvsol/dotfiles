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

# Parse shortcuts and prefix each command with its category
# This allows searching by category name to show related commands

current_category=""
output=""

while IFS= read -r line; do
    # Skip decorative lines
    [[ "$line" =~ ^#.*═ ]] && continue
    # Skip empty lines
    [[ -z "$line" ]] && continue
    
    # Check if this is a category header
    if [[ "$line" =~ ^#\ ──\ (.+)\ ─ ]]; then
        current_category="${BASH_REMATCH[1]}"
        output+="━━ ${current_category} ━━\n"
    else
        # Regular shortcut line - prefix with category for searching
        output+="[${current_category}] ${line}\n"
    fi
done < "$SHORTCUTS_FILE"

echo -e "$output" | \
    rofi -dmenu \
        -p "⌨ Shortcuts" \
        -theme-str 'window {width: 550px; height: 650px;}' \
        -theme-str 'listview {lines: 22;}' \
        -i \
        -no-custom \
    > /dev/null
