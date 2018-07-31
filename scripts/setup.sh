#!/usr/bin/env bash

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"
readonly BASE_NAME=$(basename "$0")


setup_scripts()
{
  echo "Installing scripts"
  mkdir -p "$HOME/.local/bin"
  rsync -aq --exclude "$DIR/$BASE_NAME" "$DIR"/* "$HOME/.local/bin"
  chmod 744 "$HOME/.local/bin"/*
  echo "Done installing scripts"
}

setup_scripts
