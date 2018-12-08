#!/usr/bin/env zsh

umask 022
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="symbols"

plugins=()

source "$ZSH/oh-my-zsh.sh"

# Disable colors in tab completion
zstyle ':completion:*' list-colors

test -f ~/.env && . ~/.env # if environment overwrite previous settings
