#!/usr/bin/env zsh

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="symbols"

plugins=()

source "$ZSH/oh-my-zsh.sh"

# Disable colors in tab completion
zstyle ':completion:*' list-colors

# Environment variables :
N_PREFIX="$HOME/.local/n"

PATH+=":$HOME/.local/bin"
PATH+=":$N_PREFIX/bin"
PATH+=":$HOME/.cargo/bin"

EDITOR="$(command -v vim)"

# project navigation
_zsh_goto_project()
{
    goto_project
    zle reset-prompt
}
zle -N _zsh_goto_project
bindkey ^n _zsh_goto_project

export N_PREFIX
export PATH
export EDITOR

test -f ~/.env && . ~/.env # if environment overwrite previous settings
