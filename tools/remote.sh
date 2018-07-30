#!/usr/bin/env bash

set -euo pipefail
umask g-wx,o-wx
readonly CLONE_DIR="$HOME/github.com/jRimbault"

check_command()
{
  command -v "$1" > /dev/null 2>&1 || {
    echo "Error: $1 is not installed"
    exit 1
  }
}

git_clone()
{
  mkdir -p "$CLONE_DIR"
  env git clone https://github.com/jRimbault/rc.git "$CLONE_DIR/rc" || {
    echo "Error: git clone of configuration repo failed"
    exit 1
  }
}

install()
{
  bash "$CLONE_DIR/rc/setup.sh" install
}

main()
{
  check_command "git"
  git_clone
  install
  env zsh -l
}

main
