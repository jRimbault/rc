#!/usr/bin/env bash

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"


setup_home()
{
  echo "Setting up the home directory"
  mkdir -p "$HOME/.local/bin"
  mkdir -p "$HOME/.npm"
  cp "$DIR/vim" "$HOME/.vimrc"
  cp "$DIR/gitconfig" "$HOME/.gitconfig"
  echo "Done setting up the home directory"
}

setup_home
