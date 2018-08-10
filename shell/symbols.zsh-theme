_USER_CHAR="${_USER_CHAR:-λ}"
_INSERT_CHAR="${_INSERT_CHAR:-›}"


if [[ -n $SSH_CONNECTION ]]; then
  _USER_CHAR="$USER@$HOST"
fi

minimal_vcs() {
  local stat_color="%{${fg[white]}%}" # assume it is clean
  local branch_name

  branch_name="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
  if [[ -n "$branch_name" ]]; then
    if [[ -n "$(git status --porcelain 2> /dev/null)" ]]; then
      stat_color="%{${fg[red]}%}"
    fi
    echo -n " $stat_color$branch_name%{$reset_color%}"
  fi
}

current_path() {
  parent_and_current="%2~"
  echo "%{${fg_bold[grey]}%}$parent_and_current%{$reset_color%}"
}

status_prompt() {
  # ternary expression, check last command status
  echo "%(?:%{${fg[white]}%}$1:%{${fg[red]}%}$1%{$reset_color%})"
}

prompt() {
  echo "$_USER_CHAR $(status_prompt "$_INSERT_CHAR") "
}

# single quotes to evaluate at runtime, not source time
PROMPT='$(prompt)'
RPROMPT='$(current_path)$(minimal_vcs)'
