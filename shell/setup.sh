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

ohmyzsh_shell()
{
  echo "Copying over shell profile, aliases, and function"
  mkdir -p "$HOME/.oh-my-zsh/custom/themes"
  soft_force_symlink "$DIR/ohmy.zshrc" "$HOME/.zshrc"
  soft_force_symlink "$DIR/alias" "$HOME/.oh-my-zsh/custom/alias.zsh"
  soft_force_symlink "$DIR/function" "$HOME/.oh-my-zsh/custom/function.zsh"
  soft_force_symlink "$DIR/gh" "$HOME/.oh-my-zsh/custom/gh.zsh"
  soft_force_symlink "$DIR/symbols.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/symbols.zsh-theme"
  echo "Shell profile installed"
}

purezsh_shell()
{
  echo "Copying over shell profile, aliases, and function"
  mkdir -p "$HOME/.config/zsh"
  soft_force_symlink "$DIR/simple.zshrc" "$HOME/.zshrc"
  soft_force_symlink "$DIR/alias" "$HOME/.config/zsh/alias"
  soft_force_symlink "$DIR/function" "$HOME/.config/zsh/function"
  soft_force_symlink "$DIR/gh" "$HOME/.config/zsh/gh"
  soft_force_symlink "$DIR/symbols.zsh-theme" "$HOME/.config/zsh/theme"
  echo "Shell profile installed"
}

main()
{
  has zsh || exit 0
  if ask "Install with oh-my-zsh ?" Y; then
    install_ohmyzsh
    ohmyzsh_shell
  else
    purezsh_shell
  fi
}

# do not execute script if it is sourced or downloaded-piped to bash
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  main "$@"
fi
