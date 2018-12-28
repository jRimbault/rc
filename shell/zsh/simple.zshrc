#!/usr/bin/env zsh

umask 022
autoload -Uz compinit promptinit
compinit
promptinit

# Disable colors in tab completion
zstyle ':completion:*' list-colors
zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}
# Arrow driven autocompletion interface
zstyle ':completion:*' menu select

test -f ~/.config/zsh/theme && . ~/.config/zsh/theme
test -f ~/.config/zsh/alias && . ~/.config/zsh/alias
test -f ~/.config/zsh/function && . ~/.config/zsh/function
test -f ~/.config/zsh/gh && . ~/.config/zsh/gh
test -f ~/.config/zsh/keybings && . ~/.config/zsh/keybings
test -f ~/.def-env-vars && . ~/.def-env-vars

test -f ~/.env && . ~/.env # if environment overwrite previous settings
