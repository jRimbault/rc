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


usage()
{
  grep "^#/" "$0" | cut -c4-
  exit 0
}

get_apt_packages()
{
  cat "$BASE_DIR/packages/apt"
}

list_packages()
{
  echo "List of system packages to be installed :"
  for package in $(get_apt_packages); do
    echo " $package"
  done
  exit 0
}

update()
{
  cd "$BASE_DIR" &&
  git fetch &&
  git reset --hard origin/master
}

main()
{
  for DIR in "$BASE_DIR"/*; do
    [ -d "$DIR" ] || continue;
    [ -f "$DIR/setup.sh" ] || continue;
    bash "$DIR/setup.sh"
  done
  exit 0
}

args()
{
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        ;;
      -p|--packages)
        list_packages
        ;;
      i|install)
        main
        ;;
      u|update)
        update &&
        bash "$BASE_DIR/setup.sh" install
        ;;
    esac
    shift
  done
}


# do not execute script if it is sourced or downloaded-piped to bash
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  args "$@"
  usage
fi
