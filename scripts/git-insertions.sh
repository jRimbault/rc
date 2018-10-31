#!/usr/bin/env bash
#/ Script Name: git-insertions.sh
#/ Author: jRimbault
#/ Date:   2017-06-08
#/
#/ Description:
#/   How much has a author participated to a git project
#/   Show the total insertions, total insertions and total files changed
#/   by a author on a branch
#/
#/ Usage: git-insertions.sh <author> <branch>
#/   <author> required
#/   <branch> default to "master"
#/
#/ Options:
#/   --help, -h display this help
usage()
{
  grep "^#/" "$0" | cut -c4-
  exit 0
}

git_log()
{
  git log --author="$1" --shortstat "$2"
}

# each line beginning with a space and number
# add all first string
# add all fourth string
# add all sixth string
# ex: " 2 files changed, 35 insertions(+), 40 deletions(-)"
awk_script()
{
  awk '/^ [0-9]/ {
    files += $1
    inserts += $4
    delets += $6
  } END {
    printf("%d files changed, %d insertions(+), %d deletions(-)\n",
            files, inserts, delets)
  }'
}

main()
{
  local USER
  local BRANCH
  USER="$1"
  BRANCH=${2:-"master"}
  echo "$USER on $BRANCH"
  git_log "$USER" "$BRANCH" | awk_script
}

# executes only when executed directly not sourced
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  [[ "$*" =~ .*--help ]] > /dev/null ||
  [[ "$*" =~ .*-h ]] > /dev/null && usage
  if [[ $# -lt 1 ]]; then
    echo "<author> required"
    usage
  fi
  main "$@"
fi
