#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n'
readonly DIR="$(dirname "$(readlink -e "$0")")"
source "$(dirname "$DIR")/shell/common/function"
readonly N_PREFIX="$HOME/.local/n"


get_packages()
{
  cat "$DIR/$1"
}

install_apt_packages()
{
  echo "Installing system packages"
  local -a packages
  packages=($(get_packages apt))
  sudo apt-get update -qq
  sudo apt-get install -qq "${packages[@]}"
  sudo apt-get autoremove -qq
  echo "System packages installed"
}

install_pacman_packages()
{
  echo "Installing system packages"
  local -a packages
  packages=($(get_packages pacman))
  sudo pacman -Syyq
  sudo pacman -Sq "${packages[@]}"
  echo "System packages installed"
}

node_managed_installer()
{
  [[ "$(command -v n)" = *"$N_PREFIX"* ]] && return 1
  echo "Installing n, the nodejs manager"
  local url
  url="https://raw.github.com/mklement0/n-install/stable/bin/n-install"
  mkdir -p "$HOME/.local"
  export N_PREFIX
  set +e
  curl -L "$url" | bash -s -- -q lts
  set -e
  PATH="$PATH:$N_PREFIX/bin"
  export PATH
  echo "Nodejs and n installed"
}

install_npm_packages()
{
  echo "Installing npm packages"
  local -a packages
  packages=($(get_packages npm))
  "$N_PREFIX"/bin/npm install -g --silent "${packages[@]}"
  echo "Npm packages installed"
}

install_pip_packages()
{
  echo "Installing pip packages"
  local -a packages
  packages=($(get_packages pip))
  python3 -m pip install --upgrade pip
  python3 -m pip install --user -q "${packages[@]}"
  echo "Pip packages installed"
}

debian()
{
  has "apt-get" || return 1
  install_apt_packages
}

archlinux()
{
  has "pacman" || return 1
  install_pacman_packages
}

system_packages()
{
  debian || archlinux
}

main()
{
  ask "Install system packages ?" N &&
  system_packages &&
  ask "Install pip packages ?" N &&
  install_pip_packages

  ask "Install Nodejs ?" N &&
  node_managed_installer &&
  ask "Install npm packages ?" N &&
  install_npm_packages

  exit 0
}

# do not execute script if it is sourced or downloaded-piped to bash
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  main "$@"
fi
