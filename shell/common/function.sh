#!/usr/bin/env bash

# goes up the directory tree by $1 amount
up()
{
  if [[ "$#" -lt 1 ]]; then
    cd .. && return $?
  fi
  local var
  var=""
  for ((i = 0; i < $1; i++)); do
    var="../$var"
  done
  cd "$var" && return $?
}

# colorizing man-pages
man()
{
  env \
  LESS_TERMCAP_mb=$'\e[36m' \
  LESS_TERMCAP_md=$'\e[36m' \
  LESS_TERMCAP_me=$'\e[0m'  \
  LESS_TERMCAP_se=$'\e[0m'  \
  LESS_TERMCAP_so=$'\e[1m'  \
  LESS_TERMCAP_ue=$'\e[0m'  \
  LESS_TERMCAP_us=$'\e[31m' \
  man "$@"
}

# swap two files
swap()
{
  local tmp
  tmp="$(mktemp)"
  mv "$1" "$tmp" &&
  mv "$2" "$1" &&
  mv "$tmp" "$2"
}

# archiving to make funny named files
archive()
{
  echo "Archiving old '$1'"
  mv --backup=numbered "$1" "$1.bak"
}

# automatic symlinking
# archive the old file if exists
soft_force_symlink()
{
  if [ ! -e "$2" ]; then
    if [ -f "$2" ]; then
      rm "$2"
    fi
    ln -s "$1" "$2"
    return $?
  fi
  if [ -n "$(diff --brief "$2" "$1")" ]; then
    archive "$2"
  fi
  if [ -e "$2" ]; then
    rm "$2"
  fi
  ln -sf "$1" "$2"
}

# add file to path
add_to_path()
{
  local target dest realfile
  realfile="$(basename "$1")"
  target="$(readlink -e "$(dirname "$1")")/$realfile"
  dest="$HOME/.local/bin/$realfile"
  soft_force_symlink "$target" "$dest"
}

# update my dotfiles
dotfiles_update()
{
  local witness
  local rc_clone
  witness="$HOME/.zshrc"
  rc_clone="$(dirname "$(dirname "$(readlink -e "$witness")")")"
  bash "$rc_clone/setup.sh" update
}

# This is a general-purpose function to ask Yes/No questions in Bash, either
# with or without a default answer. It keeps repeating the question until it
# gets a valid answer.
ask() {
  # https://djm.me/ask
  local prompt default reply

  if [ "${2:-}" = "Y" ]; then
    prompt="Y/n"
    default=Y
  elif [ "${2:-}" = "N" ]; then
    prompt="y/N"
    default=N
  else
    prompt="y/n"
    default=
  fi

  while true; do
    # Ask the question (not using "read -p" as it uses stderr not stdout)
    echo -n "$1 [$prompt] "

    # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
    # shellcheck disable=SC2162
    read reply </dev/tty

    # Default?
    if [ -z "$reply" ]; then
      reply=$default
    fi

    # Check if the reply is valid
    case "$reply" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac
  done
}

# check if system has $1 installedin the path
has()
{
  command -v "$1" > /dev/null 2>&1 || {
    echo "$1 is not installed"
    return 1
  }
  return 0
}

# hide fugly sed syntax
__remove_trailing_dotgit()
{
  sed -e 's/\(.*\)\/.git/\1/'
}

__remove_base_dir()
{
  sed 's,'"$1"',,g'
}

# return list of git repos under $1
# tested other solutions, all were slower...
#  - "find "$1" -name .git -type d -prune | sed -e 's/\(.*\)\/.git/\1/'" 0.4s
#  - "find "$1" -name .git -type d -prune | xargs -n 1 dirname" 0.8s
#  - "find "$1" -type d -exec test -e '{}/.git' ';' -print -prune" 1.1s
# you really can't beat sed
find_git_repos()
{
  find "$1" -name .git -type d -prune |
    __remove_trailing_dotgit |
    __remove_base_dir "$1/"
}

# fuzzy projects finder
goto_project()
{
  local dest base_dir
  GH_BASE_DIR=${GH_BASE_DIR:-"$HOME/Documents"}
  base_dir="$(dirname "$GH_BASE_DIR")"
  dest=$(find_git_repos "$base_dir" | fzy)
  [ -z "$dest" ] && return 0
  cd "$base_dir/$dest" || return 1
}

# show the last 10 commits
git_log_pager_short()
{
  local format
  format='%Cred%h%Creset %Cgreen%cr %Cblue%an%Creset %s%C(yellow)%d%Creset'
  # shellcheck disable=2048 disable=2086
  git log -10 --graph --pretty="$format" $* 2> /dev/null
}

# fuzzy find among the 500 lasts commands issued
history_fuzzy_finder()
{
  local exe
  exe="$(tail -n 500 "$HISTFILE" | cut -d';' -f 2 | fzy)"
  echo "$exe"
  eval "$exe"
}

# using function to "stringify" all function's args
# making actual args non mutable
mpv_yta() {
  mpv --ytdl-format=bestaudio ytdl://ytsearch:"$*"
}

# run command on all git revisions since last push
run_since_last_push()
{
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD)
  run-command-on-git-revisions.sh origin/"$branch" "$branch" "$*"
}

gfb()
{
  git branch | cut -c 3- | fzy
}

# fuzzy git checkout
fco()
{
  gfb | xargs git checkout
}
