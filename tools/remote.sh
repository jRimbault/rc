#!/usr/bin/env bash

set -euo pipefail
umask g-wx,o-wx

check_command()
{
  command -v "$1" > /dev/null 2>&1 || {
    echo "Error: $1 is not installed"
    exit 1
  }
}

git_clone()
{
  mkdir -p "$HOME/github.com/jRimbault"
  env git clone https://github.com/jRimbault/rc.git "$HOME/github.com/jRimbault/rc" || {
    echo "Error: git clone of configuration repo failed"
    exit 1
  }
}

install()
{
  bash "$HOME/github.com/jRimbault/rc/setup.sh" install
}

main()
{
  check_command "git"
  git_clone
  install
  env zsh -l
}

main
