# ALIAS #

alias ll = eza -laHhg --color=always -s=type --time-style=long-iso
alias l = eza -a --color=auto -s=type
alias pb = curl -F "c=@-" "http://fars.ee/?u=1"
alias py = python3
alias rsi = rust-script
alias v = lvim
alias la = lazygit
alias lj = lazyjj

# INTEGRATION #

source $"($nu.cache-dir)/carapace.nu"
source $"($nu.cache-dir)/zoxide.nu"
source $"($nu.cache-dir)/navi.nu"
source $"($nu.cache-dir)/mise.nu"
source $"($nu.cache-dir)/atuin.nu"

# FUNCTION #

def --env zd [] {
    let p = fd -c 'always' -H -I -E '.git' . | fzf --ansi --cycle
    if ($p | path type) == 'dir' {
        z $p
    } else {
        z ($p | path dirname)
    }
}

# 快速提交，内容为当前时区的时间戳
def t-git [] {
	git commit -m $"(date now | format date '%Y-%m-%d %H:%M:%S')"
}

# 交换文件名
def swap [lhs: string, rhs: string] {
	mv $lhs $"($lhs).swapping"
	mv $rhs $lhs
	mv $"($lhs).swapping" $rhs
}

# 移形换影
def --env yazi-nav [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# 检查文件编码
def cke [...items: string] {
    $items
    | default --empty { ls | get name }
    | where {|f| ($f | path type) == 'file'}
    | par-each {|path|
        {
            file: $path,
            encoding: (enca -i -L zh $path),
        }
    }
}

# 查看文件的平台
def plf [...texts: string] {
    $texts
    | default --empty { ls | get name }
    | where {|t| ($t | path type) == 'file' }
    | par-each {|text|
        let platform = (
            if (file $text) !~ 'text' {
                '???'
            } else if (open -r $text) =~ (char crlf) {
                'dos'
            } else {
                'unix'
            }
        )

        {
            file: $text,
            platform: $platform,
        }
    }
}

# KEYMAP #

$env.config.keybindings ++= [
    {
        name: "yazi",
        modifier: control,
        keycode: char_v,
        mode: [emacs],
        event: {
            send: executehostcommand,
            cmd: yazi-nav,
        }
    }
]
