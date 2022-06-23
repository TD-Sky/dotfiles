#!/usr/bin/zsh

# Lines configured by zsh-newuser-install
export HISTFILE="$HOME/.cache/zsh/histfile"
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

source "$HOME/.config/etc/init.sh"
