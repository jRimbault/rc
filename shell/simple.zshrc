#!/usr/bin/env zsh

autoload -Uz compinit promptinit
compinit
promptinit

# History search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "$key[Up]"   ]] && bindkey -- "$key[Up]"   up-line-or-beginning-search
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-beginning-search

# Disable colors in tab completion
zstyle ':completion:*' list-colors
# Arrow driven autocompletion interface
zstyle ':completion:*' menu select

test -f ~/.config/zsh/theme && . ~/.config/zsh/theme
test -f ~/.config/zsh/alias && . ~/.config/zsh/alias
test -f ~/.config/zsh/function && . ~/.config/zsh/function
test -f ~/.config/zsh/gh && . ~/.config/zsh/gh
test -f ~/.env && . ~/.env

# Environment variables :

N_PREFIX="$HOME/.local/n"

PATH+=":$HOME/.local/bin"
PATH+=":$N_PREFIX/bin"
PATH+=":$HOME/.cargo/bin"

EDITOR="$(command -v vim)"


export N_PREFIX
export PATH
export EDITOR
