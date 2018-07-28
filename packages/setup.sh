#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n'
readonly DIR="$(dirname "$(readlink -e "$0")")"


get_apt_packages()
{
  cat "$DIR/apt"
}

install_system_packages()
{
  echo "Setting up the system packages"
  local packages
  packages=($(get_apt_packages))
  sudo apt-get update -q
  sudo apt-get install -qy "${packages[@]}"
  sudo apt-get autoremove -qy
  echo "System packages installed"
}

install_system_packages
