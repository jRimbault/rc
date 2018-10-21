#!/usr/bin/env bash
#/ Author: jRimbault
#/
#/ Sometimes I want to write a log of the day.
#/ And I like to have them organized.
#/
#/ Options:
#/   --help, -h display this help

set -euo pipefail
readonly JOURNAL="$HOME/Documents/Journal"


usage()
{
  grep "^#/" "$0" | cut -c4-
  exit 0
}

main()
{
  local month="$(date +%Y-%m)"
  [ -d "$JOURNAL/$month" ] || mkdir -p "$JOURNAL/$month"
  local day="$(date +%d)"
  $EDITOR "$JOURNAL/$month/$day".md
}

dispatch()
{
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        ;;
    esac
    shift
  done

  main
}

# executes only when executed directly not sourced
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  dispatch "$@"
fi
