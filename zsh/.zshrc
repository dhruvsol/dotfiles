# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Zsh Configuration
# ═══════════════════════════════════════════════════════════════

# ── Zinit (Plugin Manager) ────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Auto-install zinit if not present
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# ── Plugins ───────────────────────────────────────────────────
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Oh-My-Zsh snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# ── Completion ────────────────────────────────────────────────
autoload -Uz compinit && compinit
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ── History ───────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# ── Options ───────────────────────────────────────────────────
setopt AUTO_CD
setopt CORRECT
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

# ── Key Bindings ──────────────────────────────────────────────
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ── Colors ────────────────────────────────────────────────────
autoload -Uz colors && colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# ── Aliases ───────────────────────────────────────────────────
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Editor
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# System
alias reload='source ~/.zshrc'
alias cls='clear'
alias grep='grep --color=auto'

# Tmux
alias t='tmux'
alias ta='tmux attach'
alias tn='tmux new -s'

# ── Environment ───────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export BROWSER='librewolf'

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# ── Prompt (Starship) ─────────────────────────────────────────
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ── FZF ───────────────────────────────────────────────────────
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh 2>/dev/null)" || {
        # Fallback for older fzf versions
        [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
        [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
    }
    
    # Theme (Sakura Night)
    export FZF_DEFAULT_OPTS="
        --color=bg+:#1a1b26,bg:#1a1b26,spinner:#bb9af7,hl:#f7768e
        --color=fg:#c0caf5,header:#7dcfff,info:#e0af68,pointer:#bb9af7
        --color=marker:#9ece6a,fg+:#c0caf5,prompt:#bb9af7,hl+:#f7768e
        --height=40% --layout=reverse --border=rounded
    "
    
    # Use fd if available
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
fi

# ── Zoxide ────────────────────────────────────────────────────
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias cdi='zi'
fi

# ── Local config ──────────────────────────────────────────────
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
