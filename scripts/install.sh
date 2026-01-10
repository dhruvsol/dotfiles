#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# Sakura Night - Arch Installation Script
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
echo -e "${MAGENTA}║${NC}  ${CYAN}🌸 Sakura Night - Arch Installer${NC}      ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}\n"

# ── Check if running on Arch ────────────────────────────────────
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}✗${NC} This script is for Arch-based systems only!"
    exit 1
fi

# ── Helper functions ────────────────────────────────────────────
install_packages() {
    local packages=("$@")
    echo -e "\n${BLUE}Installing: ${NC}${packages[*]}\n"
    sudo pacman -S --needed --noconfirm "${packages[@]}" || true
}

section() {
    echo -e "\n${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# ── Update system ───────────────────────────────────────────────
section "Updating system"
sudo pacman -Syu --noconfirm

# ── Core packages ───────────────────────────────────────────────
section "Installing core packages"
install_packages \
    git \
    stow

# ── Hyprland & Wayland ──────────────────────────────────────────
section "Installing Hyprland & Wayland"
install_packages \
    hyprland \
    hyprpaper \
    xdg-desktop-portal-hyprland \
    wl-clipboard

# ── Terminal ────────────────────────────────────────────────────
section "Installing terminal"
install_packages \
    alacritty \
    tmux

# ── Status Bar ──────────────────────────────────────────────────
section "Installing Waybar"
install_packages \
    waybar

# ── App Launcher ────────────────────────────────────────────────
section "Installing Rofi"
install_packages \
    rofi

# ── Audio (for Waybar volume control) ───────────────────────────
section "Installing audio"
install_packages \
    pipewire \
    pipewire-pulse \
    wireplumber \
    playerctl

# ── Display (for Waybar backlight) ──────────────────────────────
section "Installing display utilities"
install_packages \
    brightnessctl

# ── Network ─────────────────────────────────────────────────────
section "Installing network tools"
install_packages \
    networkmanager

# ── Fonts ───────────────────────────────────────────────────────
section "Installing fonts"
install_packages \
    ttf-jetbrains-mono-nerd \
    noto-fonts \
    noto-fonts-emoji

# ── Icons (for Rofi) ────────────────────────────────────────────
section "Installing icons"
install_packages \
    papirus-icon-theme

# ── Browser ─────────────────────────────────────────────────────
section "Installing browser"
install_packages \
    firefox

# ── Enable Services ─────────────────────────────────────────────
section "Enabling services"

echo -e "${BLUE}Enabling NetworkManager...${NC}"
sudo systemctl enable --now NetworkManager 2>/dev/null || true

echo -e "${BLUE}Enabling PipeWire...${NC}"
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true

# ── Stow Dotfiles ───────────────────────────────────────────────
section "Stowing dotfiles"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

if [[ -f "$DOTFILES_DIR/scripts/stow.sh" ]]; then
    chmod +x "$DOTFILES_DIR/scripts/stow.sh"
    bash "$DOTFILES_DIR/scripts/stow.sh"
else
    echo -e "${YELLOW}!${NC} stow.sh not found, skipping dotfiles"
fi

# ── Make scripts executable ─────────────────────────────────────
section "Setting permissions"
find "$DOTFILES_DIR" -name "*.sh" -exec chmod +x {} \;
echo -e "${GREEN}✓${NC} Made all scripts executable"

# ── Done ────────────────────────────────────────────────────────
echo -e "\n${MAGENTA}╔════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}  ${GREEN}✓ Installation Complete!${NC}              ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"

echo -e "\n${CYAN}Next steps:${NC}"
echo -e "  1. Log out and select Hyprland at login"
echo -e "  2. Press ${BLUE}Super + Q${NC} for terminal"
echo -e "  3. Press ${BLUE}Super + R${NC} for app launcher"
echo -e "  4. Press ${BLUE}Super + /${NC} for shortcuts menu"
echo -e ""
