#!/usr/bin/env bash

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"
source "$(dirname "$DIR")/shell/common/function.sh"


setup_scripts()
{
  echo "Installing scripts"
  mkdir -p "$HOME/.bin"
  for script in "$DIR"/*; do
    if [ -d "$script" ]; then
      continue
    fi
    soft_force_symlink "$script" "$HOME/.bin/$(basename "$script")"
  done
  rm "$HOME/.bin/$(basename "$0")"
  chmod 744 "$HOME/.bin"/*
  echo "Done installing scripts"
}

main()
{
  setup_scripts
}

# do not execute script if it is sourced or downloaded-piped to bash
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  main "$@"
fi
