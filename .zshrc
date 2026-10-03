# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# =========================
# FZF-TAB CONFIGURATION
# =========================

# UI & Layout Options
# Minimalist border style, customized highlight colors, and compact preview height
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
# Directory Preview for 'ls' / 'eza' (Compact list format with icons)
zstyle ':fzf-tab:complete:(ls|eza):*' fzf-preview \
  'eza -1 --color=always --icons=always $realpath 2>/dev/null || ls -1 $realpath'
# File & Directory Preview for Editors/Readers (cat, nano, vim, nvim, bat, code, etc.)
# Displays syntax-highlighted file contents via 'bat' or directory contents via 'eza'
zstyle ':fzf-tab:complete:(cat|bat|nano|vim|nvim|less|code):*' fzf-preview \
  'if [ -f $realpath ]; then bat --color=always --line-range :500 $realpath 2>/dev/null || head -n 100 $realpath; elif [ -d $realpath ]; then eza --tree --level=2 --color=always --icons=always $realpath 2>/dev/null || ls -1 $realpath; fi'
# System Process Preview (for 'kill' command)
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags --preview-window=down:3:wrap
# Environment Variables Preview (e.g., echo $PATH)
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset):*' fzf-preview 'echo ${(P)word}'
# Manual Pages Preview (man command)
zstyle ':fzf-tab:complete:man:*' fzf-preview 'MANPAGER=cat man ${word%%\(*} 2>/dev/null'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview 'MANPAGER=cat man ${word%%\(*} 2>/dev/null'
# Git Commands Preview (git add, checkout, log, diff)
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta 2>/dev/null || git diff $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git show $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git log -n 5 --oneline --color=always $word'

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
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

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# fnm
FNM_PATH="/home/ifo/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

[[ -s "/home/ifo/.gvm/scripts/gvm" ]] && source "/home/ifo/.gvm/scripts/gvm"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
