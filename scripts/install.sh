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

install_aur() {
    local packages=("$@")
    if command -v yay &> /dev/null; then
        echo -e "\n${BLUE}Installing (AUR): ${NC}${packages[*]}\n"
        yay -S --needed --noconfirm "${packages[@]}" || true
    elif command -v paru &> /dev/null; then
        echo -e "\n${BLUE}Installing (AUR): ${NC}${packages[*]}\n"
        paru -S --needed --noconfirm "${packages[@]}" || true
    else
        echo -e "${YELLOW}!${NC} No AUR helper found. Skipping: ${packages[*]}"
        echo -e "  Install yay or paru first for AUR packages."
    fi
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
    base-devel \
    git \
    stow \
    wget \
    curl \
    unzip

# ── Hyprland & Wayland ──────────────────────────────────────────
section "Installing Hyprland & Wayland"
install_packages \
    hyprland \
    xdg-desktop-portal-hyprland \
    xdg-utils \
    wayland \
    wayland-protocols \
    wl-clipboard \
    cliphist \
    grim \
    slurp

# ── Display & Graphics ──────────────────────────────────────────
section "Installing display utilities"
install_packages \
    brightnessctl \
    qt5-wayland \
    qt6-wayland

# ── Terminal & Shell ────────────────────────────────────────────
section "Installing terminal & shell"
install_packages \
    alacritty \
    tmux \
    zsh \
    starship

# ── Status Bar ──────────────────────────────────────────────────
section "Installing Waybar"
install_packages \
    waybar

# ── App Launcher ────────────────────────────────────────────────
section "Installing Rofi"
install_packages \
    rofi

# ── Audio ───────────────────────────────────────────────────────
section "Installing audio"
install_packages \
    pipewire \
    pipewire-alsa \
    pipewire-audio \
    pipewire-pulse \
    wireplumber \
    pavucontrol \
    playerctl

# ── Network ─────────────────────────────────────────────────────
section "Installing network tools"
install_packages \
    networkmanager \
    network-manager-applet \
    nm-connection-editor

# ── Notifications ───────────────────────────────────────────────
section "Installing notifications"
install_packages \
    dunst \
    libnotify

# ── File Manager ────────────────────────────────────────────────
section "Installing file manager"
install_packages \
    thunar \
    tumbler \
    gvfs

# ── Fonts ───────────────────────────────────────────────────────
section "Installing fonts"
install_packages \
    ttf-jetbrains-mono-nerd \
    ttf-font-awesome \
    noto-fonts \
    noto-fonts-emoji \
    noto-fonts-cjk

# ── Themes & Icons ──────────────────────────────────────────────
section "Installing themes"
install_packages \
    papirus-icon-theme \
    gnome-themes-extra \
    gtk-engine-murrine

# ── Screenshot & Screen ─────────────────────────────────────────
section "Installing screenshot tools"
install_packages \
    grim \
    slurp \
    swappy

# ── Lock Screen ─────────────────────────────────────────────────
section "Installing lock screen"
install_packages \
    hyprlock

# ── Wallpaper ───────────────────────────────────────────────────
section "Installing wallpaper daemon"
install_packages \
    hyprpaper

# ── Browser ─────────────────────────────────────────────────────
section "Installing browser"
install_packages \
    firefox

# ── AUR Packages (optional) ─────────────────────────────────────
section "Installing AUR packages"

# Check for AUR helper, install yay if not present
if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
    echo -e "${YELLOW}Installing yay (AUR helper)...${NC}"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
fi

install_aur \
    wlogout \

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

if [[ -f "$DOTFILES_DIR/stow.sh" ]]; then
    chmod +x "$DOTFILES_DIR/stow.sh"
    bash "$DOTFILES_DIR/stow.sh"
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
echo -e ""
echo -e "${YELLOW}Optional:${NC}"
echo -e "  • Set zsh as default: ${BLUE}chsh -s /bin/zsh${NC}"
echo -e "  • Update font cache: ${BLUE}fc-cache -fv${NC}"
echo -e ""

