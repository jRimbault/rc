#!/usr/bin/env zsh

autoload -Uz compinit promptinit
compinit
promptinit

# Disable colors in tab completion
zstyle ':completion:*' list-colors
# Arrow driven autocompletion interface
zstyle ':completion:*' menu select

test -f ~/.config/zsh/theme && . ~/.config/zsh/theme
test -f ~/.config/zsh/alias && . ~/.config/zsh/alias
test -f ~/.config/zsh/function && . ~/.config/zsh/function
test -f ~/.config/zsh/gh && . ~/.config/zsh/gh
test -f ~/.config/zsh/keybings && . ~/.config/zsh/keybings

# Environment variables :
N_PREFIX="$HOME/.local/n"

PATH+=":$HOME/.local/bin"
PATH+=":$N_PREFIX/bin"
PATH+=":$HOME/.cargo/bin"

EDITOR="$(command -v vim)"

export N_PREFIX
export PATH
export EDITOR

test -f ~/.env && . ~/.env # if environment overwrite previous settings
