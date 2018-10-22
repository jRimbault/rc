#!/usr/bin/env bash

# system management
alias service='sudo service'
alias svim='sudoedit'
alias apt='sudo apt'
alias zshconfig='$EDITOR ~/.zshrc'

# list aliases
alias ls='ls --color=never --group-directories-first'
alias lsa='ls -A'
alias ll='ls -lh'
alias l='ls -lha'

LOG_FORMAT='%Cred%h%Creset %Cgreen%cr %Cblue%an%Creset %s%C(yellow)%d%Creset'

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
alias gf='git fetch'
alias gl='git pull'
alias glg='git log --graph --stat'
alias glga='git log --graph --stat --decorate --all'
alias glol='git log --graph --pretty="$LOG_FORMAT"'
alias glola='git log --graph  --all --pretty="$LOG_FORMAT"'
alias gp='git push'
alias gpd='git push --dry-run'
alias gss='git status -s'
alias gst='git status'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'

# python
alias pip='python3 -m pip' # debian has/had a packaging issue with pip

# network
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias mirror-website="wget --mirror --convert-links --adjust-extension --page-requisites --no-parent"

# project management
alias goto='goto_project'