#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Neovim Setup Script
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
echo -e "${MAGENTA}║${NC}  ${CYAN}🌸 Neovim Setup - Sakura Night${NC}        ${MAGENTA}║${NC}"
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

# ── Install Neovim ──────────────────────────────────────────────
install_neovim() {
    section "Installing Neovim"
    
    if command -v nvim &> /dev/null; then
        local version=$(nvim --version | head -1)
        success "Neovim already installed: $version"
    else
        info "Installing Neovim..."
        case $PM in
            pacman) $INSTALL neovim ;;
            apt)    
                # Ubuntu/Debian - use PPA for latest
                sudo add-apt-repository -y ppa:neovim-ppa/unstable 2>/dev/null || true
                sudo apt update
                $INSTALL neovim
                ;;
            dnf)    $INSTALL neovim ;;
            brew)   $INSTALL neovim ;;
        esac
        success "Neovim installed"
    fi
}

# ── Install dependencies ────────────────────────────────────────
install_deps() {
    section "Installing dependencies"
    
    # Core dependencies (includes C compiler for Treesitter)
    info "Installing core dependencies..."
    case $PM in
        pacman)
            $INSTALL git curl unzip ripgrep fd nodejs npm gcc tree-sitter
            ;;
        apt)
            $INSTALL git curl unzip ripgrep fd-find nodejs npm build-essential
            ;;
        dnf)
            $INSTALL git curl unzip ripgrep fd-find nodejs npm gcc gcc-c++
            ;;
        brew)
            $INSTALL git curl unzip ripgrep fd node tree-sitter
            ;;
    esac
    success "Core dependencies installed"
    
    # Nerd Font (for icons)
    info "Checking for Nerd Font..."
    case $PM in
        pacman)
            $INSTALL ttf-jetbrains-mono-nerd
            ;;
        brew)
            brew tap homebrew/cask-fonts 2>/dev/null || true
            brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || true
            ;;
        *)
            warn "Install JetBrains Mono Nerd Font manually from: https://www.nerdfonts.com"
            ;;
    esac
    success "Font check complete"
}

# ── Stow Neovim config ──────────────────────────────────────────
stow_config() {
    section "Setting up config"
    
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
    NVIM_CONFIG="$HOME/.config/nvim"
    
    # Backup existing config
    if [[ -d "$NVIM_CONFIG" ]] && [[ ! -L "$NVIM_CONFIG" ]]; then
        info "Backing up existing config..."
        mv "$NVIM_CONFIG" "$NVIM_CONFIG.backup.$(date +%Y%m%d%H%M%S)"
        success "Backup created"
    fi
    
    # Create symlink
    mkdir -p "$HOME/.config"
    if [[ -d "$DOTFILES_DIR/nvim" ]]; then
        ln -sfn "$DOTFILES_DIR/nvim" "$NVIM_CONFIG"
        success "Config linked: $NVIM_CONFIG → $DOTFILES_DIR/nvim"
    else
        error "nvim config not found in dotfiles!"
        exit 1
    fi
}

# ── Install plugins ─────────────────────────────────────────────
install_plugins() {
    section "Installing plugins"
    
    info "Running Neovim to install plugins..."
    info "(This may take a minute on first run)"
    
    # Run nvim headless to install plugins
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    
    success "Plugins installed"
    
    # Install/update Treesitter parsers
    info "Installing Treesitter parsers..."
    nvim --headless "+TSUpdate" +qa 2>/dev/null || true
    
    success "Treesitter parsers installed"
}

# ── Verify installation ────────────────────────────────────────
verify() {
    section "Verification"
    
    echo -e "\n  ${BLUE}Neovim:${NC} $(nvim --version | head -1)"
    echo -e "  ${BLUE}Config:${NC} $HOME/.config/nvim"
    echo -e "  ${BLUE}Data:${NC}   $HOME/.local/share/nvim"
    
    # Check tools
    echo ""
    for cmd in git node npm rg fd; do
        if command -v $cmd &> /dev/null; then
            success "$cmd installed"
        else
            warn "$cmd not found"
        fi
    done
}

# ── Main ────────────────────────────────────────────────────────
main() {
    detect_pm
    install_neovim
    install_deps
    stow_config
    install_plugins
    verify
    
    echo -e "\n${MAGENTA}╔════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}  ${GREEN}✓ Neovim Setup Complete!${NC}              ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
    
    echo -e "\n${CYAN}Quick start:${NC}"
    echo -e "  ${BLUE}nvim${NC}              Open Neovim"
    echo -e "  ${BLUE}Space + e${NC}         File explorer"
    echo -e "  ${BLUE}Space + ff${NC}        Find files"
    echo -e "  ${BLUE}Space + E${NC}         Split vertical"
    echo -e "  ${BLUE}Space + W${NC}         Split horizontal"
    echo -e ""
}

main "$@"

