#!/usr/bin/env bash
#/ Author: jRimbault
#/
#/ Used to setup a new, persitent, environment for me.
#/
#/ Options:
#/   --help, -h display this help
#/   --packages, -p display the list of system packages to install
#/   install, i execute the setup script
#/   upgrade, u install updates from the repo

set -euo pipefail
readonly BASE_DIR="$(dirname "$(readlink -e "$0")")"
readonly LOG_FILE="/tmp/$(basename "$0").log"

exec >  >(tee -ia "$LOG_FILE")
exec 2> >(tee -ia "$LOG_FILE" >&2)


usage()
{
  grep "^#/" "$0" | cut -c4-
  exit 0
}

get_packages()
{
  cat "$BASE_DIR/packages/$1"
}

display_list()
{
  local package
  echo "List of $1 packages to be installed :"
  for package in $(get_packages "$1"); do
    echo " $package"
  done
}

list_packages()
{
  display_list apt
  display_list npm
  display_list pip
}

update()
{
  cd "$BASE_DIR" &&
  git fetch &&
  git reset --hard origin/master
}

main()
{
  local arg
  local dir
  arg="${1:=install}"
  for dir in "$BASE_DIR"/*; do
    [ -d "$dir" ] || continue;
    [ -f "$dir/setup.sh" ] || continue;
    bash "$dir/setup.sh" "$arg"
  done
}

main()
{
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        ;;
      -p|--packages)
        list_packages | less
        exit 0
        ;;
      i|install)
        main
        exit 0
        ;;
      iu|install-update)
        main update
        exit 0
        ;;
      u|update)
        update &&
        bash "$BASE_DIR/setup.sh" install-update
        exit 0
        ;;
    esac
    shift
  done
}


# do not execute script if it is sourced or downloaded-piped to bash
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  main "$@"
  usage
fi
