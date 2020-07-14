#!/usr/bin/env bash

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"
source "$(dirname "$DIR")/shell/common/function.sh"


git_config()
{
  mkdir -p "$HOME/.config"
  soft_force_symlink "$DIR/git" "$HOME/.config/git"
}

vim_config()
{
  local config_dir
  config_dir="$HOME/.config/nvim"
  mkdir -p "$config_dir"
  mkdir -p "$config_dir/colors"
  mkdir -p "$config_dir/autoload"
  soft_force_symlink "$DIR/vim/init.vim" "$config_dir/init.vim"
  soft_force_symlink "$DIR/vim/onedark.vim/autoload/airline" "$config_dir/autoload/airline"
  soft_force_symlink "$DIR/vim/onedark.vim/autoload/lightline" "$config_dir/autoload/lightline"
  soft_force_symlink "$DIR/vim/onedark.vim/autoload/onedark.vim" "$config_dir/autoload/onedark.vim"
  soft_force_symlink "$DIR/vim/onedark.vim/colors/onedark.vim" "$config_dir/colors/onedark.vim"
  soft_force_symlink "$DIR/vim/vim-monochrome/colors/monochrome.vim"
  "$config_dir/colors/monochrome.vim"
}

setup_home()
{
  echo "Setting up the home directory"
  mkdir -p "$HOME/.local/bin"
  mkdir -p "$HOME/.npm"
  git_config
  vim_config
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
