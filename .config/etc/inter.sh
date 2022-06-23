# 如果是非交互式则退出，仅在交互模式下初始化
[[ $- != *i* ]] && return

[[ -n "$INTER_DONE" ]] && return

source "$ETC/fn.sh"
source "$ETC/unsync.sh"

if [ -n "$ZSH_VERSION" ]; then
	SH='zsh'
	set -o vi
	source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
	source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
elif [ -n "$BASH_VERSION" ]; then
	SH='bash'
fi

eval "$(zoxide init $SH)"
eval "$(starship init $SH)"
eval "$(fnm env --use-on-cd)"
eval "$(mcfly init $SH)"

INTER_DONE=1
