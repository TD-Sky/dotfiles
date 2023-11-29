# git

## 快速提交，内容为当前时区的时间戳
function t-git {
	git commit -m "$(date --rfc-3339 seconds)"
}

##################################################

# 文件系统

alias ls='eza -a --color=auto -s=type'
alias ll='eza -laHhg --color=always -s=type --time-style=long-iso'
alias dirs="eza -Fa1 --color=never -s=type | rg '/' -r ''"

## 交换文件名
function swap {
	mv $1 "$1.swapping"
	mv $2 $1
	mv "$1.swapping" $2
}

## yazi移动
function ya {
	tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

##################################################

# 编译/解释

## 现代C++编译
alias mcpp='clang++ -std=c++2a -Wall -Werror'

function dot-png {
	dot -Tpng $1 -o "$(echo $1 | choose -f '\.' 0).png"
}

alias py='python'
alias rsi='rust-script'

##################################################

# vim

## 只读
function vr {
	cat "${1:-/dev/stdin}" | lvim -R
}

## 创建配套目录
alias d4v='mkdir -p $XDG_CACHE_HOME/nvim/{backup,info,swap,undo}'

##################################################

# 复制/粘贴

if [[ $XDG_BACKEND == 'wayland' ]]; then
    alias xs='wl-copy'
	alias xp='wl-paste -n'
else
	alias xs='xclip -sel c'
	alias xp='xclip -sel c -o'
fi
