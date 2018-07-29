#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n'
readonly DIR="$(dirname "$(readlink -e "$0")")"
readonly N_PREFIX="$HOME/.local/n"


get_packages()
{
  cat "$DIR/$1"
}

install_system_packages()
{
  echo "Setting up the system packages"
  local packages
  packages=($(get_packages apt))
  sudo apt-get update -q
  sudo apt-get install -qy "${packages[@]}"
  sudo apt-get autoremove -qy
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
  echo "Setting up the npm packages"
  local packages
  packages=($(get_packages npm))
  ~/.local/n/bin/npm install -g --silent "${packages[@]}"
  echo "Npm packages installed"
}

install_system_packages
node_managed_installer &&
install_npm_packages
