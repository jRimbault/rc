#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n'
readonly DIR="$(dirname "$(readlink -e "$0")")"
source "$(dirname "$DIR")/shell/function"
readonly N_PREFIX="$HOME/.local/n"


has()
{
  command -v "$1" > /dev/null 2>&1 || {
    echo "Error: $1 is not installed"
    return 1
  }
  return 0
}

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
  echo "Nodejs manager installer"
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
  python3 -m pip install --user -qq "${packages[@]}"
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
  system_packages && \
    install_pip_packages
  node_managed_installer && \
    install_npm_packages
}

main
