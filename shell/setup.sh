#!/usr/bin/env bash

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"
source "$(dirname "$DIR")/shell/common/function.sh"


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
  echo "Copying over Zed shell profile, aliases, and function"
  mkdir -p "$HOME/.oh-my-zsh/custom/themes"
  soft_force_symlink "$DIR/zsh/ohmy.zshrc" "$HOME/.zshrc"
  soft_force_symlink "$DIR/common/alias.sh" "$HOME/.oh-my-zsh/custom/alias.zsh"
  soft_force_symlink "$DIR/common/function.sh" "$HOME/.oh-my-zsh/custom/function.zsh"
  soft_force_symlink "$DIR/common/gh.sh" "$HOME/.oh-my-zsh/custom/gh.zsh"
  soft_force_symlink "$DIR/zsh/keybings.zsh" "$HOME/.oh-my-zsh/custom/keybings.zsh"
  soft_force_symlink "$DIR/zsh/symbols.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/symbols.zsh-theme"
  echo "Zed shell profile installed"
}

purezsh_shell()
{
  echo "Copying over Zed shell profile, aliases, and function"
  mkdir -p "$HOME/.config/zsh"
  soft_force_symlink "$DIR/zsh/simple.zshrc" "$HOME/.zshrc"
  soft_force_symlink "$DIR/common/alias.sh" "$HOME/.config/zsh/alias"
  soft_force_symlink "$DIR/common/function.sh" "$HOME/.config/zsh/function"
  soft_force_symlink "$DIR/common/gh.sh" "$HOME/.config/zsh/gh"
  soft_force_symlink "$DIR/zsh/keybings.zsh" "$HOME/.config/zsh/keybings"
  soft_force_symlink "$DIR/zsh/symbols.zsh-theme" "$HOME/.config/zsh/theme"
  echo "Zed shell profile installed"
}

bash_shell()
{
  echo "Copying over Bourne Again shell profile, aliases, and function"
  mkdir -p "$HOME/.config/bash"
  soft_force_symlink "$DIR/bash/bashrc" "$HOME/.bashrc"
  soft_force_symlink "$DIR/bash/inputrc" "$HOME/.inputrc"
  soft_force_symlink "$DIR/common/alias.sh" "$HOME/.config/bash/alias.sh"
  soft_force_symlink "$DIR/common/function.sh" "$HOME/.config/bash/function.sh"
  soft_force_symlink "$DIR/common/gh.sh" "$HOME/.config/bash/gh.sh"
  soft_force_symlink "$DIR/bash/theme" "$HOME/.config/bash/theme.sh"
  echo "Bourne Again shell profile installed"
}

profile()
{
  soft_force_symlink "$DIR/common/profile" "$HOME/.config/bash/.profile"
  soft_force_symlink "$DIR/common/profile" "$HOME/.config/bash/.zprofile"
}

main()
{
  if ask "Install bash profile ?" Y; then
    bash_shell
    profile
  fi
  has zsh || exit 0
  if ask "Install with oh-my-zsh ?" N; then
    install_ohmyzsh
    ohmyzsh_shell
    profile
    exit 0
  fi
  if ask "Install with native zsh profile ?" N; then
    purezsh_shell
    profile
    exit 0
  fi

}

# do not execute script if it is sourced or downloaded-piped to bash
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  main "$@"
fi
