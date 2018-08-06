#!/usr/bin/env bash

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"
source "$(dirname "$DIR")/shell/function"


install_ohmyzsh()
{
  echo "Installing Oh-My-Zsh"
  local url
  url="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
  sudo chsh -s "$(command -v zsh)" "$USER"
  set +e
  wget -qO - "$url" | sh
  set -e
  echo "Oh-My-Zsh installed"
}


setup_shell()
{
  echo "Copying over shell profile, aliases, and function"
  mkdir -p "$HOME/.oh-my-zsh/custom/themes"
  soft_force_symlink "$DIR/zshrc" "$HOME/.zshrc"
  soft_force_symlink "$DIR/alias" "$HOME/.oh-my-zsh/custom/alias.zsh"
  soft_force_symlink "$DIR/function" "$HOME/.oh-my-zsh/custom/function.zsh"
  soft_force_symlink "$DIR/symbols.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/symbols.zsh-theme"
  echo "Shell profile installed"
}

install_ohmyzsh
setup_shell
