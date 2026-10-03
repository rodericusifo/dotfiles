# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# =========================
# FZF-TAB CONFIGURATION
# =========================

# UI & Layout Options
zstyle ':fzf-tab:*' fzf-flags \
  --color=bg+:-1,fg+:#d0d0d0,hl+:#5fd7ff \
  --bind=tab:accept \
  --height=60% \
  --layout=reverse \
  --border=rounded \
  --info=inline \
  --preview-window=right:50%:wrap

# Completion Group Sorting & Styling
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Switch Completion Groups Using ',' and '.' Keys
zstyle ':fzf-tab:*' switch-group ',' '.'

# PREVIEW CUSTOMIZATION
# ------------------------------------------
# Directory Preview (for 'cd' and directory navigation)
if command -v eza &> /dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --color=always --icons=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
fi

# Directory Preview for 'ls' / 'eza'
zstyle ':fzf-tab:complete:(ls|eza):*' fzf-preview \
  'eza -1 --color=always --icons=always $realpath 2>/dev/null || ls -1 $realpath'

# File & Directory Preview for Editors/Readers
zstyle ':fzf-tab:complete:(cat|bat|nano|vim|nvim|less|code):*' fzf-preview \
  'if [ -f $realpath ]; then bat --color=always --line-range :500 $realpath 2>/dev/null || head -n 100 $realpath; elif [ -d $realpath ]; then eza --tree --level=2 --color=always --icons=always $realpath 2>/dev/null || ls -1 $realpath; fi'

# System Process Preview (for 'kill' command)
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags --preview-window=down:3:wrap

# Environment Variables Preview
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset):*' fzf-preview 'echo ${(P)word}'

# Manual Pages Preview
zstyle ':fzf-tab:complete:man:*' fzf-preview 'MANPAGER=cat man ${word%%\(*} 2>/dev/null'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview 'MANPAGER=cat man ${word%%\(*} 2>/dev/null'

# Git Commands Preview
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta 2>/dev/null || git diff $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git show $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git log -n 5 --oneline --color=always $word'


# =========================
# OH MY ZSH PLUGINS
# =========================

plugins=(
    git
    uv
    python
    fnm
    bun
    node
    gvm
    golang
    z
    sudo
    copypath
    copyfile
    web-search
    extract
    docker
    docker-compose
    kubectl
    you-should-use
    fzf
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


# =========================
# ALIASES & USER CONFIG
# =========================

# Load shared exports
[ -f "$HOME/.exports" ] && source "$HOME/.exports"

# Load shared aliases
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Homebrew (Linuxbrew)
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi
