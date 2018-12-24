#!/usr/bin/env bash

# filesystem
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'


# system management
alias svi='sudoedit'
alias svim='sudoedit'
alias apt='sudo apt'
alias zshconfig='$EDITOR ~/.zshrc'

# list aliases
alias ls='ls --color=never --group-directories-first'
alias lsa='ls -A'
alias ll='ls -lh'
alias l='ls -lha'

# git
alias g='git'
alias ga='git add'
alias gau='git add --update'
alias gb='git branch'
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcb='git checkout -b'
alias gcl='git clone --recursive'
alias gco='git checkout'
alias gd='git diff'
alias gdw='git diff --word-diff'
alias gf='git fetch -v'
alias gl='git pull'
alias gp='git push'
alias gpd='git push --dry-run'
alias gss='git status -s'
alias gst='git status'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gfb='git branch | cut -c 3- | fzf'
alias fco='gfb | xargs git checkout'

# python
alias pip='python3 -m pip' # debian has/had a packaging issue with pip
alias pr='pipenv run'
alias prp='pipenv run python'

# network
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias mirror-website="wget --mirror --convert-links --adjust-extension --page-requisites --no-parent"
alias http-server='python3 -m http.server --bind 127.0.0.1 8080'

# project management
alias p='goto_project'

# text files
alias vi="vim"
alias vim="vim"
alias sed-trailing-whitespace="sed 's/[[:space:]]\\+$//'"

# media
alias playlist-dl='youtube-dl --extract-audio --ignore-errors --audio-format mp3 -o "%(autonumber)s - %(title)s.%(ext)s"'

# journal
alias journal='git journal'
