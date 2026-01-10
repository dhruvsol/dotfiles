#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - LibreWolf Setup Script
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "\n${MAGENTA}╔════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}  ${CYAN}🌸 LibreWolf Setup - Sakura Night${NC}     ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}\n"

# ── Helper functions ────────────────────────────────────────────
success() { echo -e "  ${GREEN}✓${NC} $1"; }
info() { echo -e "  ${BLUE}→${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
error() { echo -e "  ${RED}✗${NC} $1"; }

# ── Find dotfiles directory ────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
LIBREWOLF_DOTFILES="$DOTFILES_DIR/librewolf"

if [[ ! -d "$LIBREWOLF_DOTFILES" ]]; then
    error "LibreWolf dotfiles not found at: $LIBREWOLF_DOTFILES"
    exit 1
fi

# ── Find LibreWolf profile directory ────────────────────────────
LIBREWOLF_DIR="$HOME/.librewolf"

if [[ ! -d "$LIBREWOLF_DIR" ]]; then
    warn "LibreWolf directory not found. Starting LibreWolf to create profile..."
    
    # Start LibreWolf briefly to create profile
    if command -v librewolf &> /dev/null; then
        timeout 5 librewolf --headless 2>/dev/null || true
        sleep 2
    else
        error "LibreWolf is not installed!"
        echo -e "  Install with: ${BLUE}yay -S librewolf-bin${NC}"
        exit 1
    fi
fi

# ── Find the default profile ────────────────────────────────────
info "Looking for LibreWolf profile..."

# Read profiles.ini to find default profile
PROFILES_INI="$LIBREWOLF_DIR/profiles.ini"

if [[ ! -f "$PROFILES_INI" ]]; then
    error "profiles.ini not found. Please run LibreWolf once first."
    exit 1
fi

# Find the default profile path
PROFILE_PATH=""

# Try to find default profile
while IFS='=' read -r key value; do
    key=$(echo "$key" | tr -d '[:space:]')
    value=$(echo "$value" | tr -d '[:space:]' | tr -d '\r')
    
    if [[ "$key" == "Path" ]]; then
        CURRENT_PATH="$value"
    fi
    
    if [[ "$key" == "Default" && "$value" == "1" ]]; then
        PROFILE_PATH="$CURRENT_PATH"
        break
    fi
done < "$PROFILES_INI"

# If no default found, use the first profile
if [[ -z "$PROFILE_PATH" ]]; then
    PROFILE_PATH=$(grep -m1 "^Path=" "$PROFILES_INI" | cut -d'=' -f2 | tr -d '\r')
fi

if [[ -z "$PROFILE_PATH" ]]; then
    error "Could not find profile path in profiles.ini"
    exit 1
fi

# Handle relative vs absolute path
if [[ "$PROFILE_PATH" != /* ]]; then
    FULL_PROFILE_PATH="$LIBREWOLF_DIR/$PROFILE_PATH"
else
    FULL_PROFILE_PATH="$PROFILE_PATH"
fi

if [[ ! -d "$FULL_PROFILE_PATH" ]]; then
    error "Profile directory not found: $FULL_PROFILE_PATH"
    exit 1
fi

success "Found profile: $PROFILE_PATH"

# ── Copy chrome directory ───────────────────────────────────────
info "Installing userChrome.css and userContent.css..."

CHROME_DIR="$FULL_PROFILE_PATH/chrome"
mkdir -p "$CHROME_DIR"

# Copy CSS files
if [[ -d "$LIBREWOLF_DOTFILES/chrome" ]]; then
    cp -f "$LIBREWOLF_DOTFILES/chrome/userChrome.css" "$CHROME_DIR/" 2>/dev/null && \
        success "Installed userChrome.css" || warn "userChrome.css not found"
    
    cp -f "$LIBREWOLF_DOTFILES/chrome/userContent.css" "$CHROME_DIR/" 2>/dev/null && \
        success "Installed userContent.css" || warn "userContent.css not found"
fi

# ── Copy user.js ────────────────────────────────────────────────
info "Installing user.js preferences..."

if [[ -f "$LIBREWOLF_DOTFILES/user.js" ]]; then
    cp -f "$LIBREWOLF_DOTFILES/user.js" "$FULL_PROFILE_PATH/"
    success "Installed user.js"
else
    warn "user.js not found in dotfiles"
fi

# ── Done ────────────────────────────────────────────────────────
echo -e "\n${MAGENTA}╔════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}  ${GREEN}✓ LibreWolf Setup Complete!${NC}          ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"

echo -e "\n${CYAN}Files installed to:${NC}"
echo -e "  ${BLUE}$FULL_PROFILE_PATH${NC}"
echo -e "\n${CYAN}Next steps:${NC}"
echo -e "  1. Close LibreWolf completely"
echo -e "  2. Restart LibreWolf to see the new theme"
echo -e ""

