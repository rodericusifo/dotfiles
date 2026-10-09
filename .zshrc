# =========================
# ANTIDOTE PLUGIN MANAGER
# =========================

# Source antidote
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh

# Static plugin loading (generates and sources ~/.zsh_plugins.zsh)
if [[ ! ${ZDOTDIR:-$HOME}/.zsh_plugins.zsh -nt ${ZDOTDIR:-$HOME}/.zsh_plugins.txt ]]; then
  antidote load
fi
source ${ZDOTDIR:-$HOME}/.zsh_plugins.zsh

# =========================
# FZF-TAB CONFIGURATION
# =========================

zstyle ':fzf-tab:*' fzf-flags \
  --color=bg+:-1,fg+:#d0d0d0,hl+:#5fd7ff \
  --bind=tab:accept \
  --height=60% \
  --layout=reverse \
  --border=rounded \
  --info=inline \
  --preview-window=right:50%:wrap

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' switch-group ',' '.'

# PREVIEW CUSTOMIZATION
if command -v eza &> /dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --color=always --icons=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
fi

zstyle ':fzf-tab:complete:(ls|eza):*' fzf-preview \
  'eza -1 --color=always --icons=always $realpath 2>/dev/null || ls -1 $realpath'

zstyle ':fzf-tab:complete:(cat|bat|nano|vim|nvim|less|code):*' fzf-preview \
  'if [ -f $realpath ]; then bat --color=always --line-range :500 $realpath 2>/dev/null || head -n 100 $realpath; elif [ -d $realpath ]; then eza --tree --level=2 --color=always --icons=always $realpath 2>/dev/null || ls -1 $realpath; fi'

# System Process Preview (Cross-Platform OS Check)
if [[ "$OSTYPE" == "darwin"* ]]; then
  zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps -p $word -o command='
else
  zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers'
fi
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags --preview-window=down:3:wrap

zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset):*' fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:man:*' fzf-preview 'MANPAGER=cat man ${word%%\(*} 2>/dev/null'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview 'MANPAGER=cat man ${word%%\(*} 2>/dev/null'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta 2>/dev/null || git diff $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git show $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git log -n 5 --oneline --color=always $word'

# =========================
# ALIASES & USER CONFIG
# =========================

# Load shared exports & aliases
[ -f "$HOME/.exports" ] && source "$HOME/.exports"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# FNM Initialization
if command -v fnm &> /dev/null; then
  eval "$(fnm env --shell zsh)"
fi

# GVM Initialization
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Cross-Platform Homebrew (macOS Apple Silicon / macOS Intel / Linux)
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [ -f "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv zsh)"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

# =========================
# STARSHIP PROMPT
# =========================
eval "$(starship init zsh)"
