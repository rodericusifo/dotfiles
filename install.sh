#!/bin/bash

set -e # Exit immediately on error

echo "🚀 Starting dotfiles automated setup..."

# 1. Install System Dependencies & CLI Tools (fzf, eza, bat, delta)
if ! command -v git &> /dev/null || ! command -v zsh &> /dev/null || ! command -v curl &> /dev/null; then
    echo "📦 Installing core system dependencies..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y git zsh curl fzf bat
    elif command -v brew &> /dev/null; then
        brew install git zsh curl fzf eza bat git-delta
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm git zsh curl fzf eza bat git-delta
    fi
fi

# 2. Install Oh My Zsh (unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "💡 Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 3. Download Custom Plugins & Themes Required by your .zshrc
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "🔌 Cloning Powerlevel10k theme and custom plugins..."

# Powerlevel10k Theme
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

# Zsh Plugins defined in your plugins=(...)
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

[ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ] && \
    git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"

[ ! -d "$ZSH_CUSTOM/plugins/you-should-use" ] && \
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$ZSH_CUSTOM/plugins/you-should-use"

[ ! -d "$ZSH_CUSTOM/plugins/gvm" ] && \
    git clone https://github.com/rodericusifo/zsh-gvm.git "$ZSH_CUSTOM/plugins/gvm"

# 4. Setup Bare Repository Dotfiles
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/rodericusifo/dotfiles.git"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "📥 Cloning bare repository dotfiles..."
    git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

function dotfiles {
   /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

echo "⚙️ Applying dotfiles configurations to $HOME..."

# Backup conflicting files
dotfiles checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} {}.bak 2>/dev/null || true

# Force checkout configuration files
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no

# 5. Change Default Shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Changing default shell to Zsh..."
    chsh -s "$(which zsh)" || true
fi

echo "✅ Setup complete! Restart your terminal or run: exec zsh"
