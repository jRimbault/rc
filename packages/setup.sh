#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n'
readonly DIR="$(dirname "$(readlink -e "$0")")"
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
  local packages
  packages=($(get_packages apt))
  sudo apt-get update -q
  sudo apt-get install -qy "${packages[@]}"
  sudo apt-get autoremove -qy
  echo "System packages installed"
}

install_pacman_packages()
{
  echo "Installing system packages"
  local packages
  packages=($(get_packages pacman))
  sudo pacman -Syy
  sudo pacman -S "${packages[@]}"
  echo "System packages installed"
}

node_managed_installer()
{
  echo "Installing n, the nodejs manager"
  local url
  url="https://git.io/n-install"
  mkdir -p "$HOME/.local"
  export N_PREFIX
  set +e
  curl -L "$url" | bash -s -- -y lts
  set -e
  PATH="$PATH:$N_PREFIX/bin"
  export PATH
  echo "Nodejs manager installer"
}

install_npm_packages()
{
  echo "Installing npm packages"
  local packages
  packages=($(get_packages npm))
  "$N_PREFIX"/bin/npm install -g --silent "${packages[@]}"
  echo "Npm packages installed"
}

install_pip_packages()
{
  echo "Installing pip packages"
  local packages
  packages=($(get_packages pip))
  pip3 install --user -qq "${packages[@]}"
  echo "Pip packages installed"
}

debian()
{
  has "apt-get" && \
    install_apt_packages && \
    return 0
  return 1
}

archlinux()
{
  has "pacman" && \
    install_pacman_packages && \
    return 0
  return 1
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
