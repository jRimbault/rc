#!/usr/bin/env bash

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"
source "$(dirname "$DIR")/shell/function"


setup_home()
{
  echo "Setting up the home directory"
  mkdir -p "$HOME/.local/bin"
  mkdir -p "$HOME/.npm"
  soft_force_symlink "$DIR/vim" "$HOME/.vimrc"
  soft_force_symlink "$DIR/gitconfig" "$HOME/.gitconfig"
  echo "Done setting up the home directory"
}

setup_home
