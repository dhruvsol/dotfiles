# 🌸 Sakura Night Dotfiles

Minimal Hyprland rice with a cherry blossom twilight aesthetic.

![Theme](hypr/bg.jpeg)

## What's Included

| Component     | Config                                |
| ------------- | ------------------------------------- |
| **Hyprland**  | Window manager with smooth animations |
| **Waybar**    | Vertical status bar (right side)      |
| **Alacritty** | Terminal with transparency            |
| **Rofi**      | Compact app launcher                  |
| **VS Code**   | Editor settings & keybindings         |

## Installation

```bash
# Clone
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install dependencies (Arch)
sudo pacman -S hyprland waybar alacritty rofi \
    ttf-jetbrains-mono-nerd \
    brightnessctl playerctl \
    networkmanager pulseaudio-utils

# Stow configs
chmod +x stow.sh
./stow.sh
```

## Keybindings

| Key           | Action           |
| ------------- | ---------------- |
| `Super + Q`   | Terminal         |
| `Super + R`   | App launcher     |
| `Super + C`   | Close window     |
| `Super + B`   | Browser          |
| `Super + W`   | Reload wallpaper |
| `Super + 1-9` | Switch workspace |

## Waybar Controls

| Module     | Click        | Right-click | Scroll |
| ---------- | ------------ | ----------- | ------ |
| Volume     | Popup slider | Mute toggle | ±5%    |
| Brightness | 50%          | 100%        | ±5%    |
| Network    | nmtui        | Toggle WiFi | -      |
| Media      | Play/pause   | Next        | Volume |

## Color Palette

```
Background:  #1a1b26
Foreground:  #c0caf5
Accent:      #bb9af7 (Lavender)
Pink:        #f7768e
Cyan:        #7dcfff
Green:       #9ece6a
Yellow:      #e0af68
Orange:      #ff9e64
```

## Structure

```
dotfiles/
├── alacritty/     # Terminal config
├── hypr/          # Hyprland + wallpaper
├── waybar/        # Status bar + scripts
├── rofi/          # App launcher theme
├── code/          # VS Code settings
└── stow.sh        # Symlink manager
```

## TODO

- [ ] Add dunst notification daemon config
- [ ] Add lock screen (hyprlock/swaylock)
- [ ] Add logout menu (wlogout)
- [ ] Add screenshot tool (grim + slurp)
- [ ] Add clipboard manager (cliphist)
- [ ] Add GTK theme to match color palette
- [ ] Add cursor theme
- [ ] Add zsh/starship prompt config
- [ ] Add tmux config
- [ ] Add neovim config

---

_Inspired by Tokyo Night theme_
