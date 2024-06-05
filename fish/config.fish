# rust 工具链镜像源
set -gx RUSTUP_DIST_SERVER 'https://mirrors.ustc.edu.cn/rust-static'
set -gx RUSTUP_UPDATE_ROOT 'https://mirrors.ustc.edu.cn/rust-static/rustup'

# 用户可执行程序目录
set -gx PATH \
    $HOME/.cargo/bin \
    $PATH \
    $HOME/.local/bin \
    $HOME/.local/share/JetBrains/Toolbox/scripts \
    /usr/lib/rustup/bin \
    /usr/lib/jvm/default/bin

# 默认编辑器
set -gx EDITOR 'lvim'

# nodejs 本体镜像
set -gx FNM_NODE_DIST_MIRROR 'https://npmmirror.com/mirrors/node'

# XDG
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_DATA_HOME "$HOME/.local/share"

# go 镜像源
set -gx GOPROXY 'https://goproxy.cn'

# mcfly
set -gx MCFLY_FUZZY 2
set -gx MCFLY_RESULTS '25'

# 解决webkit与N卡的冲突
set -gx WEBKIT_DISABLE_DMABUF_RENDERER 1

if status is-interactive
    # 禁掉打招呼
    set fish_greeting

    # git
    ## 快速提交，内容为当前时区的时间戳
    function t-git
        git commit -m (date --rfc-3339 seconds)
    end

    function yazi-nav
        set tmp (mktemp -t "yazi-cwd.XXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    # 文件系统
    alias ls='eza -a --color=auto -s=type'
    alias ll='eza -laHhg --color=always -s=type --time-style=long-iso'
    alias dirs="eza -Fa1 --color=never -s=type | rg '/' -r ''"

    ## 交换文件名
    function swap
        mv $argv[1] "$argv[1].swapping"
        mv $argv[2] $argv[1]
        mv "$argv[1].swapping" $argv[2]
    end

    # 编译/解释
    ## 现代C++编译
    alias mcpp='clang++ -std=c++2a -Wall -Werror'

    function dot-png
        dot -Tpng $argv[1] -o "$(echo $argv[1] | choose -f '\.' 0).png"
    end

    alias py='python3'
    alias rsi='rust-script'

    ## 创建配套目录
    alias d4v='mkdir -p $XDG_CACHE_HOME/nvim/{backup,info,swap,undo}'

    # 快捷键
    bind \co 'edit_command_buffer'
    bind \cy 'yazi-nav'

    # 启动
    zoxide init fish | source
    starship init fish | source
    fnm env --use-on-cd | source
    mcfly init fish | source
    # atuin init fish | source
    navi widget fish | source
end
