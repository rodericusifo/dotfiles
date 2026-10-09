#!/bin/bash

set -e

echo "🚀 Starting automated dotfiles setup..."

# 1. Install System Dependencies & CLI Tools
echo "📦 Installing core system dependencies..."
if command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y git zsh curl fzf eza bat git-delta zoxide btop fastfetch unzip
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm git zsh curl fzf eza bat git-delta zoxide btop fastfetch unzip
elif command -v brew &> /dev/null; then
    # Install general tools that won't conflict with macOS defaults
    brew install git zsh fzf eza bat git-delta zoxide btop fastfetch

    # Handle curl and unzip safely on macOS (skip if already available)
    echo "Checking curl and unzip..."
    for pkg in curl unzip; do
        if ! brew list "$pkg" &> /dev/null; then
            brew install "$pkg" || echo "⚠️ Notice: Skipped or handled system default for $pkg."
        fi
    done
fi

# Symlink batcat to bat for Debian/Ubuntu systems
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
fi

# 2. Install Oh My Posh Prompt
if ! command -v oh-my-posh &> /dev/null; then
    echo "🎨 Installing Oh My Posh prompt..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# 3. Install Antidote Plugin Manager
if [ ! -d "$HOME/.antidote" ]; then
    echo "🔌 Installing Antidote plugin manager..."
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
fi

# 4. Setup & Synchronize Bare Repository Dotfiles
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/rodericusifo/dotfiles.git"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "📥 Cloning bare repository dotfiles..."
    git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

function dotfiles {
   /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

echo "⚙️ Syncing dotfiles configuration to $HOME..."

dotfiles config --local status.showUntrackedFiles no
dotfiles config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

dotfiles fetch origin main
dotfiles reset --hard FETCH_HEAD

# 5. Build Static Antidote Plugins File on First Run
if [ -f "$HOME/.zsh_plugins.txt" ] && [ ! -f "$HOME/.zsh_plugins.zsh" ]; then
    echo "⚡ Pre-compiling Zsh plugins with Antidote..."
    zsh -c "source $HOME/.antidote/antidote.zsh && antidote bundle < $HOME/.zsh_plugins.txt > $HOME/.zsh_plugins.zsh"
fi

# 6. Change Default Shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Changing default shell to Zsh..."
    chsh -s "$(which zsh)" || true
fi

echo "✅ Setup complete! Open a new terminal or run: source ~/.zshrc"
