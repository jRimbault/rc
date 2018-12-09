#!/usr/bin/env bash
# journaling


declare -A ALIASES=(
  [read]="log"
  [write]="commit --allow-empty"
  [save]="push"
)

main()
{
  local arg
  arg="$1"
  if [ ${ALIASES[$1]+_} ]; then
    arg="${ALIASES[$1]}"
  fi
  shift
  run_command "$arg" "$@"
  exit $?
}

usage()
{
  echo "Usage: $(basename "$0") <git subcommand>"
  echo "Additional subcommands:"
  for key in "${!ALIASES[@]}"; do
    echo " $key : alias of '${ALIASES[$key]}'"
  done
}

run_command()
{
  local journal
  journal="${JOURNAL_REPO:-$HOME/log}"

  git --git-dir "$journal/.git" \
    --work-tree "$journal" \
    $*
}


# do not execute script if it is sourced or downloaded-piped to bash
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  if [ $# -lt 1 ]; then
    usage
    exit 1
  fi

  main "$@"
fi
