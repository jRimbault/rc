#!/usr/bin/env bash

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"
source "$(dirname "$DIR")/shell/function"
readonly BASE_NAME=$(basename "$0")


setup_scripts()
{
  echo "Installing scripts"
  mkdir -p "$HOME/.local/bin"
  for script in "$DIR"/*; do
    soft_force_symlink "$script" "$HOME/.local/bin/$(basename "$script")"
  done
  rm "$HOME/.local/bin/setup.sh"
  chmod 744 "$HOME/.local/bin"/*
  echo "Done installing scripts"
}

setup_scripts
