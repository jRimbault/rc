#!/usr/bin/env bash

set -euo pipefail
umask g-wx,o-wx
readonly CLONE_DIR="$HOME/Documents/github.com/jRimbault"

has()
{
  command -v "$1" > /dev/null 2>&1 || {
    echo "Error: $1 is not installed"
    return 1
  }
  return 0
}

git_clone()
{
  mkdir -p "$CLONE_DIR"
  env git clone https://github.com/jRimbault/rc.git "$CLONE_DIR/rc" || {
    echo "Error: git clone of configuration repo failed"
    exit 1
  }
}

install_all()
{
  bash "$CLONE_DIR/rc/setup.sh" install
}

main()
{
  has "git" || exit 1
  git_clone
  install_all
}

main
