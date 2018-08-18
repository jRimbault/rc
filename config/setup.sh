#!/usr/bin/env bash

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"
source "$(dirname "$DIR")/shell/function"


git_config()
{
  mkdir -p "$HOME/.config/git"
  soft_force_symlink "$DIR/git/config" "$HOME/.config/git/config"
  soft_force_symlink "$DIR/git/ignore" "$HOME/.config/git/ignore"
  soft_force_symlink "$DIR/git/helper.sh" "$HOME/.config/git/helper.sh"
}

setup_home()
{
  echo "Setting up the home directory"
  mkdir -p "$HOME/.local/bin"
  mkdir -p "$HOME/.npm"
  soft_force_symlink "$DIR/vim" "$HOME/.vimrc"
  git_config
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
