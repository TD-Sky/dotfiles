# 归档

function from-tgz {
	echo $1 | choose -f '\.' 0 | tar -zxvf $1
}

function to-tgz {
	tar -zcvf "$1.tar.gz" $1
}

function from-tzst {
	echo $1 | choose -f '\.' 0 | tar -I unzstd -xvf $1
}

function to-tzst {
	tar -I zstdmt -cvf "$1.tar.zst" $1
}

alias ls-tzst='tar -I unzstd --list -f'

## 创建7z压缩包，交互式设置密码
function to-p7z {
	7za a -tzip -p -mem=AES256 "$1.7z" $1
}

alias from-7z='7za x'

function to-zip {
	zip -r "$1.zip" $1
}

##################################################

# git

## 警醒
alias git='echo "密码明文保存于 ~/.git-credentials !" && git'

## 快速提交
function t-git {
	git commit -m "$(date +'%Y-%m-%d_%T' -u)"
}

##################################################

# 文件系统

alias ls='exa --color auto -s type -a'
alias ll='exa -laHhg --color always -s type --time-style long-iso'
alias cat='bat -pp'
alias dirs="exa -Fa1 --color never -s type | rg '/' -r ''"

## 交换文件名
function swap {
	mv $1 "$1.swapping"
	mv $2 $1
	mv "$1.swapping" $2
}

## 备份
function bak {
	cp -r $1 "$1.bak"
}

## 移动剪贴板内指定文件
function mov {
	dest='./'

	if [[ -n "$1" ]]; then
		dest=$1
	fi

	while read -r src; do
		mv $src $dest
	done < <(xclip -sel c -o)
}

## 复制剪贴板内指定文件
function clo {
	dest='./'

	if [[ -n "$1" ]]; then
		dest=$1
	fi

	while read -r src; do
		cp -r $src $dest
	done < <(xclip -sel c -o)
}

## 显示进度条的复制
alias rcp='rsync -avh --progress'

##################################################

# 编译/解释

## 现代C++编译
alias mcpp='clang++ -std=c++2a -Wall -Werror'

function dot-png {
	dot -Tpng $1 -o "$(echo $1 | choose -f '\.' 0).png"
}

alias py='python'
alias pl='perl'

##################################################

# 搜索

## 树形列印软件包的本地存在
function treepack {
	pacman -Ql $@ | choose 1 | tree -C --fromfile | less -R
}

##################################################

function proxy-on {
	export http_proxy='http://127.0.0.1:7890'
	export https_proxy='http://127.0.0.1:7890'
}

function proxy-off {
	unset http_proxy https_proxy
}

##################################################

# vim

## 只读
alias vr='lvim -R'

## 创建配套目录
alias d4v='mkdir -p $XDG_CACHE_HOME/vim/{backup,info,swap,undo}'

##################################################

# 复制/粘贴

alias xs='xclip -sel c'
alias xso='xclip -sel c -o'

##################################################

# 网络

## 公示代码
alias fars='curl -F "c=@-" "https://fars.ee/"'
