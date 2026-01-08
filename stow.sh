#!/usr/bin/env bash

# ╔══════════════════════════════════════════════════════════════╗
# ║                    Dotfiles Stow Script                      ║
# ╚══════════════════════════════════════════════════════════════╝

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Packages that go to ~/.config
CONFIG_PACKAGES=(
    "fontconfig"
    "code"
    "waybar"
)

# Packages that go to ~/.config but need special handling
# (their structure is package/file instead of package/package/file)
CONFIG_FLAT_PACKAGES=(
    "hypr"
    "alacritty"
)

# Packages that go to ~ (home directory)
# Add packages here that should be stowed directly to home
# e.g., "bash" for .bashrc, "zsh" for .zshrc
HOME_PACKAGES=(
    # "bash"
    # "zsh"
    # "git"
)

print_header() {
    echo -e "\n${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BLUE}$1${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
}

print_status() {
    echo -e "  ${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "  ${RED}✗${NC} $1"
}

print_info() {
    echo -e "  ${BLUE}→${NC} $1"
}

# Check if stow is installed
check_stow() {
    if ! command -v stow &> /dev/null; then
        print_error "GNU Stow is not installed!"
        echo -e "  Install it with: ${CYAN}sudo pacman -S stow${NC}"
        exit 1
    fi
}

# Stow a package to a target directory
stow_package() {
    local package=$1
    local target=$2
    local package_path="$DOTFILES_DIR/$package"

    if [[ ! -d "$package_path" ]]; then
        print_warning "Package '$package' not found, skipping..."
        return
    fi

    print_info "Stowing ${CYAN}$package${NC} → ${YELLOW}$target${NC}"
    
    # Use --restow to handle already stowed packages
    if stow -d "$DOTFILES_DIR" -t "$target" --restow "$package" 2>/dev/null; then
        print_status "Successfully stowed $package"
    else
        # Try to adopt existing files and restow
        print_warning "Conflict detected, attempting to adopt existing files..."
        if stow -d "$DOTFILES_DIR" -t "$target" --adopt "$package" 2>/dev/null; then
            stow -d "$DOTFILES_DIR" -t "$target" --restow "$package"
            print_status "Adopted and stowed $package"
        else
            print_error "Failed to stow $package"
        fi
    fi
}

# Handle flat packages (need to create wrapper directory structure)
stow_flat_package() {
    local package=$1
    local target=$2
    local package_path="$DOTFILES_DIR/$package"

    if [[ ! -d "$package_path" ]]; then
        print_warning "Package '$package' not found, skipping..."
        return
    fi

    # Check if this is a flat structure (no nested folder with same name)
    if [[ ! -d "$package_path/$package" ]]; then
        print_info "Converting ${CYAN}$package${NC} to proper stow structure..."
        
        # Create temp directory, move files, restructure
        local temp_dir=$(mktemp -d)
        cp -r "$package_path"/* "$temp_dir/"
        rm -rf "$package_path"/*
        mkdir -p "$package_path/$package"
        mv "$temp_dir"/* "$package_path/$package/"
        rm -rf "$temp_dir"
        
        print_status "Restructured $package for stow"
    fi

    stow_package "$package" "$target"
}

# Unstow all packages
unstow_all() {
    print_header "Unstowing all packages"

    for package in "${CONFIG_PACKAGES[@]}"; do
        if [[ -d "$DOTFILES_DIR/$package" ]]; then
            print_info "Unstowing $package from $CONFIG_DIR"
            stow -d "$DOTFILES_DIR" -t "$CONFIG_DIR" -D "$package" 2>/dev/null || true
        fi
    done

    for package in "${CONFIG_FLAT_PACKAGES[@]}"; do
        if [[ -d "$DOTFILES_DIR/$package" ]]; then
            print_info "Unstowing $package from $CONFIG_DIR"
            stow -d "$DOTFILES_DIR" -t "$CONFIG_DIR" -D "$package" 2>/dev/null || true
        fi
    done

    for package in "${HOME_PACKAGES[@]}"; do
        if [[ -d "$DOTFILES_DIR/$package" ]]; then
            print_info "Unstowing $package from $HOME"
            stow -d "$DOTFILES_DIR" -t "$HOME" -D "$package" 2>/dev/null || true
        fi
    done

    print_status "All packages unstowed"
}

# Stow all packages
stow_all() {
    print_header "Stowing dotfiles"

    # Ensure target directories exist
    mkdir -p "$CONFIG_DIR"

    echo -e "${BLUE}Stowing packages to ~/.config${NC}"
    for package in "${CONFIG_PACKAGES[@]}"; do
        stow_package "$package" "$CONFIG_DIR"
    done

    echo ""
    echo -e "${BLUE}Stowing flat packages to ~/.config${NC}"
    for package in "${CONFIG_FLAT_PACKAGES[@]}"; do
        stow_flat_package "$package" "$CONFIG_DIR"
    done

    if [[ ${#HOME_PACKAGES[@]} -gt 0 ]]; then
        echo ""
        echo -e "${BLUE}Stowing packages to ~${NC}"
        for package in "${HOME_PACKAGES[@]}"; do
            stow_package "$package" "$HOME"
        done
    fi

    echo ""
    print_status "All packages stowed successfully!"
}

# List all available packages
list_packages() {
    print_header "Available packages"

    echo -e "${BLUE}~/.config packages:${NC}"
    for package in "${CONFIG_PACKAGES[@]}"; do
        if [[ -d "$DOTFILES_DIR/$package" ]]; then
            echo -e "  ${GREEN}●${NC} $package"
        else
            echo -e "  ${RED}○${NC} $package (not found)"
        fi
    done

    echo ""
    echo -e "${BLUE}~/.config flat packages:${NC}"
    for package in "${CONFIG_FLAT_PACKAGES[@]}"; do
        if [[ -d "$DOTFILES_DIR/$package" ]]; then
            echo -e "  ${GREEN}●${NC} $package"
        else
            echo -e "  ${RED}○${NC} $package (not found)"
        fi
    done

    if [[ ${#HOME_PACKAGES[@]} -gt 0 ]]; then
        echo ""
        echo -e "${BLUE}~ (home) packages:${NC}"
        for package in "${HOME_PACKAGES[@]}"; do
            if [[ -d "$DOTFILES_DIR/$package" ]]; then
                echo -e "  ${GREEN}●${NC} $package"
            else
                echo -e "  ${RED}○${NC} $package (not found)"
            fi
        done
    fi
}

# Show usage
usage() {
    echo -e "${CYAN}Dotfiles Stow Script${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  stow      Stow all dotfiles (default)"
    echo "  unstow    Unstow all dotfiles"
    echo "  restow    Unstow then stow all dotfiles"
    echo "  list      List all available packages"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Stow all packages"
    echo "  $0 stow         # Stow all packages"
    echo "  $0 unstow       # Remove all symlinks"
    echo "  $0 restow       # Refresh all symlinks"
}

# Main
main() {
    cd "$DOTFILES_DIR"
    check_stow

    case "${1:-stow}" in
        stow)
            stow_all
            ;;
        unstow)
            unstow_all
            ;;
        restow)
            unstow_all
            stow_all
            ;;
        list)
            list_packages
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            print_error "Unknown command: $1"
            usage
            exit 1
            ;;
    esac
}

main "$@"
