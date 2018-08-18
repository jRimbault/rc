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

source "$HOME/.config/zsh/theme"
source "$HOME/.config/zsh/alias"
source "$HOME/.config/zsh/function"

# Environment variables :

N_PREFIX="$HOME/.local/n"

PATH+=":$HOME/.local/bin"
PATH+=":$N_PREFIX/bin"
PATH+=":$HOME/.cargo/bin"

EDITOR="$(command -v vim)"


export N_PREFIX
export PATH
export EDITOR
