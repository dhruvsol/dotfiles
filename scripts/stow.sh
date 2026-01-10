#!/usr/bin/env bash

# ╔══════════════════════════════════════════════════════════════╗
# ║                 Sakura Night - Dotfiles                      ║
# ║                    Stow Script for Arch                      ║
# ╚══════════════════════════════════════════════════════════════╝

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

# Packages: "folder:target_dir"
PACKAGES=(
    "hypr:$CONFIG_DIR/hypr"
    "alacritty:$CONFIG_DIR/alacritty"
    "waybar:$CONFIG_DIR/waybar"
    "rofi:$CONFIG_DIR/rofi"
    "fontconfig:$CONFIG_DIR/fontconfig"
    "code:$CONFIG_DIR/Code"
    "tmux:$CONFIG_DIR/tmux"
    "nvim:$CONFIG_DIR/nvim"
    "zsh:$HOME"
)

print_status() { echo -e "  ${GREEN}✓${NC} $1"; }
print_error() { echo -e "  ${RED}✗${NC} $1"; }
print_info() { echo -e "  ${BLUE}→${NC} $1"; }
print_warn() { echo -e "  ${YELLOW}!${NC} $1"; }

header() {
    echo -e "\n${MAGENTA}╔════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}  ${BLUE}$1${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════╝${NC}\n"
}

check_stow() {
    if ! command -v stow &> /dev/null; then
        print_error "GNU Stow is not installed!"
        echo -e "  Install: ${BLUE}sudo pacman -S stow${NC}"
        exit 1
    fi
}

check_dotfiles() {
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        print_error "Dotfiles directory not found at $DOTFILES_DIR"
        echo -e "  Clone your dotfiles there first."
        exit 1
    fi
}

stow_all() {
    header "Stowing dotfiles"

    for entry in "${PACKAGES[@]}"; do
        pkg="${entry%%:*}"
        target="${entry##*:}"

        if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
            mkdir -p "$target"
            print_info "$pkg → $target"
            
            if stow -d "$DOTFILES_DIR" -t "$target" --restow "$pkg" 2>/dev/null; then
                print_status "$pkg stowed"
            else
                stow -d "$DOTFILES_DIR" -t "$target" --adopt "$pkg" 2>/dev/null || true
                if stow -d "$DOTFILES_DIR" -t "$target" --restow "$pkg" 2>/dev/null; then
                    print_warn "$pkg adopted & stowed"
                else
                    print_error "$pkg failed"
                fi
            fi
        else
            print_warn "$pkg not found, skipping"
        fi
    done

    echo -e "\n${GREEN}✓ All done!${NC}\n"
}

unstow_all() {
    header "Unstowing dotfiles"
    
    for entry in "${PACKAGES[@]}"; do
        pkg="${entry%%:*}"
        target="${entry##*:}"

        if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
            print_info "Removing $pkg"
            stow -d "$DOTFILES_DIR" -t "$target" -D "$pkg" 2>/dev/null && \
                print_status "$pkg removed" || true
        fi
    done

    echo -e "\n${GREEN}✓ All done!${NC}\n"
}

list_packages() {
    header "Dotfiles packages"

    for entry in "${PACKAGES[@]}"; do
        pkg="${entry%%:*}"
        target="${entry##*:}"
        
        if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
            echo -e "  ${GREEN}●${NC} ${BLUE}$pkg${NC} → $target"
        else
            echo -e "  ${RED}○${NC} ${BLUE}$pkg${NC} (not found)"
        fi
    done
    echo ""
}

usage() {
    echo -e "${MAGENTA}Sakura Night Dotfiles${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  stow      Symlink all dotfiles (default)"
    echo "  unstow    Remove all symlinks"
    echo "  restow    Refresh symlinks"
    echo "  list      Show available packages"
    echo "  help      Show this message"
    echo ""
}

main() {
    check_dotfiles
    check_stow

    case "${1:-stow}" in
        stow)    stow_all ;;
        unstow)  unstow_all ;;
        restow)  unstow_all; stow_all ;;
        list)    list_packages ;;
        help|-h|--help) usage ;;
        *)
            print_error "Unknown command: $1"
            usage
            exit 1
            ;;
    esac
}

main "$@"
