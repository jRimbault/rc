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
  soft_force_symlink "$DIR/gitignore" "$HOME/.gitignore"
  soft_force_symlink "$DIR/githelper.sh" "$HOME/.githelper.sh"
  echo "Done setting up the home directory"
}

main()
{
  setup_home
}

# do not execute script if it is sourced or downloaded-piped to bash
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  main "$@"
fi
