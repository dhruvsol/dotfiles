#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Zsh Setup Script
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
echo -e "${MAGENTA}║${NC}  ${CYAN}🌸 Zsh Setup - Sakura Night${NC}           ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}\n"

# ── Helper functions ────────────────────────────────────────────
section() {
    echo -e "\n${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

success() { echo -e "  ${GREEN}✓${NC} $1"; }
info() { echo -e "  ${BLUE}→${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
error() { echo -e "  ${RED}✗${NC} $1"; }

# ── Detect package manager ──────────────────────────────────────
detect_pm() {
    if command -v pacman &> /dev/null; then
        PM="pacman"
        INSTALL="sudo pacman -S --needed --noconfirm"
    elif command -v apt &> /dev/null; then
        PM="apt"
        INSTALL="sudo apt install -y"
    elif command -v dnf &> /dev/null; then
        PM="dnf"
        INSTALL="sudo dnf install -y"
    elif command -v brew &> /dev/null; then
        PM="brew"
        INSTALL="brew install"
    else
        error "No supported package manager found!"
        exit 1
    fi
    info "Detected package manager: ${BLUE}$PM${NC}"
}

# ── Install Zsh ─────────────────────────────────────────────────
install_zsh() {
    section "Installing Zsh"
    
    if command -v zsh &> /dev/null; then
        success "Zsh already installed: $(zsh --version)"
    else
        info "Installing Zsh..."
        $INSTALL zsh
        success "Zsh installed"
    fi
}

# ── Install tools ───────────────────────────────────────────────
install_tools() {
    section "Installing shell tools"
    
    # Install git (required for zinit), fzf, zoxide, fd
    case $PM in
        pacman)
            $INSTALL git fzf zoxide fd
            ;;
        apt)
            $INSTALL git fzf zoxide fd-find
            ;;
        dnf)
            $INSTALL git fzf zoxide fd-find
            ;;
        brew)
            $INSTALL git fzf zoxide fd
            ;;
    esac
    success "Shell tools installed"
    
    info "Zinit will auto-install plugins on first zsh launch"
}

# ── Install starship prompt (optional) ──────────────────────────
install_starship() {
    section "Installing Starship prompt"
    
    if command -v starship &> /dev/null; then
        success "Starship already installed"
    else
        info "Installing Starship..."
        case $PM in
            pacman) $INSTALL starship ;;
            brew)   $INSTALL starship ;;
            *)
                # Use official installer for other distros
                curl -sS https://starship.rs/install.sh | sh -s -- -y
                ;;
        esac
        success "Starship installed"
    fi
}

# ── Link config ─────────────────────────────────────────────────
link_config() {
    section "Linking Zsh config"
    
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
    ZSHRC_SRC="$DOTFILES_DIR/zsh/.zshrc"
    ZSHRC_DST="$HOME/.zshrc"
    
    # Backup existing config
    if [[ -f "$ZSHRC_DST" ]] && [[ ! -L "$ZSHRC_DST" ]]; then
        info "Backing up existing .zshrc..."
        mv "$ZSHRC_DST" "$ZSHRC_DST.backup.$(date +%Y%m%d%H%M%S)"
        success "Backup created"
    fi
    
    # Create symlink
    if [[ -f "$ZSHRC_SRC" ]]; then
        ln -sfn "$ZSHRC_SRC" "$ZSHRC_DST"
        success "Config linked: $ZSHRC_DST → $ZSHRC_SRC"
    else
        error ".zshrc not found in dotfiles!"
        exit 1
    fi
}

# ── Set as default shell ────────────────────────────────────────
set_default_shell() {
    section "Setting Zsh as default shell"
    
    ZSH_PATH=$(which zsh)
    CURRENT_SHELL=$(basename "$SHELL")
    
    if [[ "$CURRENT_SHELL" == "zsh" ]]; then
        success "Zsh is already the default shell"
    else
        info "Current shell: $CURRENT_SHELL"
        info "Changing to: $ZSH_PATH"
        
        # Check if zsh is in /etc/shells
        if ! grep -q "$ZSH_PATH" /etc/shells; then
            info "Adding $ZSH_PATH to /etc/shells..."
            echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
        fi
        
        # Change default shell
        chsh -s "$ZSH_PATH"
        success "Default shell changed to Zsh"
        warn "Log out and back in for changes to take effect"
    fi
}

# ── Main ────────────────────────────────────────────────────────
main() {
    detect_pm
    install_zsh
    install_tools
    install_starship
    link_config
    set_default_shell
    
    echo -e "\n${MAGENTA}╔════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}  ${GREEN}✓ Zsh Setup Complete!${NC}                 ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
    
    echo -e "\n${CYAN}Next steps:${NC}"
    echo -e "  1. Log out and back in (or run ${BLUE}zsh${NC})"
    echo -e "  2. Customize ${BLUE}~/.zshrc.local${NC} for local settings"
    echo -e ""
}

main "$@"

