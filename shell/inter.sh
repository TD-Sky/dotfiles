# 如果是非交互式则退出，仅在交互模式下初始化
[[ $- != *i* ]] && return

[[ -n "$INTER_DONE" ]] && return

source "$SHELL_CONFIG_HOME/fn.sh"
LOCAL_CONFIG="$SHELL_CONFIG_HOME/unsync.sh"
[ -f $LOCAL_CONFIG ] && source $LOCAL_CONFIG

if [ -n "$ZSH_VERSION" ]; then
	SH='zsh'
	source "$HOME/.config/zsh/config.zsh"
elif [ -n "$BASH_VERSION" ]; then
	SH='bash'
fi

# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv | rg -v 'export PATH=')"
eval "$(zoxide init $SH)"
eval "$(starship init $SH)"
eval "$(fnm env --use-on-cd)"
eval "$(mcfly init $SH)"
eval "$(navi widget $SH)"
# eval "$(opam env)"

INTER_DONE=1
