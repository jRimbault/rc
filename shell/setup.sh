#!/usr/bin/env bash

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"


install_ohmyzsh()
{
  echo "Installing Oh-My-Zsh"
  local url
  url="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
  sudo chsh -s "$(command -v zsh)" "$USER"
  set +e
  wget "$url" -O - | sh
  set -e
  echo "Oh-My-Zsh installed"
}


setup_shell()
{
  echo "Copying over shell profile, aliases, and function"
  mkdir -p "$HOME/.oh-my-zsh/custom/themes"
  cp "$DIR/zshrc" "$HOME/.zshrc"
  cp "$DIR/alias" "$HOME/.oh-my-zsh/custom/alias.zsh"
  cp "$DIR/function" "$HOME/.oh-my-zsh/custom/function.zsh"
  cp "$DIR/λ.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/λ.zsh-theme"
  echo "Shell profile installed"
}

install_ohmyzsh
setup_shell
