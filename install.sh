#!/bin/bash

set -e

# --- Styling ---
GREEN='\033[1;32m'
NC='\033[0m' # No Color

echo_info() {
  echo -e "${GREEN}==> $1${NC}"
}

# --- 1. Update system ---
echo_info "Updating package lists..."
sudo apt update && sudo apt upgrade -y

# --- 2. Install required packages ---
echo_info "Installing packages: zsh, git, curl, wget, fastfetch, btop..."
sudo apt install -y zsh git curl wget fastfetch btop net-tools

# --- 3. Install Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo_info "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo_info "Oh My Zsh already installed."
fi

# --- 4. Install zsh-syntax-highlighting ---
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  echo_info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
else
  echo_info "zsh-syntax-highlighting already installed."
fi

# --- 5. Install zsh-autosuggestions ---
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  echo_info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
else
  echo_info "zsh-autosuggestions already installed."
fi

# --- 6. Install Docker and Docker Compose ---
if ! command -v docker &> /dev/null; then
  echo_info "Installing Docker and Docker Compose..."
  sudo apt install -y docker.io docker-compose
  sudo usermod -aG docker "$USER"
else
  echo_info "Docker already installed."
fi

# --- 7. Install pipes.sh ---
if [ ! -d "$HOME/pipes.sh" ]; then
  echo_info "Cloning pipes.sh..."
  git clone https://github.com/pipeseroni/pipes.sh.git "$HOME/pipes.sh"
  chmod +x "$HOME/pipes.sh/pipes.sh"
else
  echo_info "pipes.sh already installed."
fi

# --- 8. Install latest Neovim to /opt ---
if [ ! -d "/opt/nvim-linux-x86_64" ]; then
  echo_info "Installing latest Neovim..."
  TMPDIR=$(mktemp -d)
  cd "$TMPDIR"
  wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  tar -xzf nvim-linux64.tar.gz
  sudo mv nvim-linux64 /opt/nvim-linux-x86_64
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  cd ~
  rm -rf "$TMPDIR"
else
  echo_info "Neovim already installed."
fi

# --- 9. Copy custom .zshrc ---
echo_info "Copying custom .zshrc to home directory..."
cp .zshrc "$HOME/.zshrc"

# --- 10. Set Zsh as default shell ---
if [ "$SHELL" != "$(which zsh)" ]; then
  echo_info "Setting Zsh as default shell..."
  chsh -s "$(which zsh)"
else
  echo_info "Zsh is already the default shell."
fi

echo_info "✅ All done! Restart your terminal or run 'zsh' to start using your new setup."