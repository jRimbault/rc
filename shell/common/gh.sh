#!/usr/bin/env bash

# Easily manage your local git repos
# This modified form allows defining other managers
#
# Copyright (c) 2014, Jeff Dickey <jeff@dickeyxxx.com>
#
# Permission to use, copy, modify, and/or distribute this software for any purpose
# with or without fee is hereby granted, provided that the above copyright notice
# and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT,
# OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
# DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
__proto_gh()
{
  # https://github.com/jdxcode/gh
  local user repo user_path local_path base_dir proto

  if [[ $# -ne 5 ]]; then
    echo "USAGE: __proto_gh [user] [repo] [url] [base_dir] [protocol]"
    return
  fi

  user="$1"
  repo="$2"

  url=${3:-"github.com"}
  base_dir=${4:-"$HOME/Documents/Git"}
  proto=${5:-"ssh"}

  user_path="$base_dir/$user"
  local_path="$user_path/$repo"

  if [[ ! -d "$local_path" ]]; then
     if [[ "$proto" == "ssh" ]]; then
      git clone "git@$url:$user/$repo.git" "$local_path"
     elif [[ "$proto" == "https" ]]; then
      git clone "https://$url/$user/$repo.git" "$local_path"
     else
      echo "protocol must be set to ssh or https"
    fi
  fi

  # If git exited uncleanly, clean up the created user directory (if exists)
  # and don't try to `cd` into it.
  if [[ $? -ne 0 ]]; then
    if [[ -d "$user_path" ]]; then
      rm -d "$user_path"
    fi
  else
    cd "$local_path" || return 1
  fi
}

gh()
{
  local user repo

  GH_BASE_DIR=${GH_BASE_DIR:-"$HOME/github.com"}
  GH_PROTO=${GH_PROTO:-"ssh"}

  if [[ $# -lt 1 ]]; then
    echo "USAGE: gh [user] [repo]"
    return
  fi

  user="$1"

  if [[ $# -eq 1 ]]; then
    repo="$(github-repos "$user" | fzf)"
  else
    repo="$2"
  fi

  __proto_gh "$user" "$repo" "github.com" "$GH_BASE_DIR" "$GH_PROTO"
}


### example custom manager :
# __custom_git_repo_manager__()
# {
#   if [[ $# -ne 1 ]]; then
#     echo "USAGE: __custom_git_repo_manager__ [repo]"
#     return
#   fi
#   local base_dir
#   base_dir=/path/to/base/dir
#   __proto_gh "User" "$1" "your.git.url.com" "$base_dir" "ssh"
# }
