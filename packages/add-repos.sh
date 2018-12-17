#!/usr/bin/env bash

# TODO : debian ? (modern, this is only for me)
# but debian testing (buster) already has up to date packages mostly

set -euo pipefail
readonly DIR="$(dirname "$(readlink -e "$0")")"
source "$(dirname "$DIR")/shell/common/function.sh"


declare -gra UBUNTU_PPAS=(
  ppa:ondrej/php
  ppa:deadsnakes/ppa
  ppa:neovim-ppa/stable
)

is_ubuntu()
{
  source /etc/os-release
  if [[ "$NAME" == "Ubuntu" ]]; then
    return 0
  fi
  return 1
}

main()
{
  if is_ubuntu; then
    for ppa in "${UBUNTU_PPAS[@]}"; do
      sudo add-apt-repository "$ppa"
      sudo apt-get udpate -q
    done
  fi
}

# do not execute script if it is sourced or downloaded-piped to bash
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  main "$@"
fi
