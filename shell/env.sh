# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_HOME="$HOME/.local/share"

# rust 工具链镜像源
export RUSTUP_DIST_SERVER='https://mirrors.ustc.edu.cn/rust-static'
export RUSTUP_UPDATE_ROOT='https://mirrors.ustc.edu.cn/rust-static/rustup'

# 用户可执行程序目录
export PATH="$HOME/.cargo/bin:\
$PATH:\
$HOME/.local/bin:\
$XDG_DATA_HOME/JetBrains/Toolbox/scripts:\
/usr/lib/jvm/default/bin"

# fcitx5
# export XMODIFIERS='@im=fcitx'
# export GTK_IM_MODULE='fcitx'
# export QT_IM_MODULE='fcitx'
# export SDL_IM_MODULE='fcitx'
# export QT_QPA_PLATFORMTHEME='qt5ct'

# vimtex 工作缓存目录
# export VIMTEX_OUTPUT_DIRECTORY='./target/tex'

# 默认编辑器
export EDITOR='lvim'

# nodejs 本体镜像
export FNM_NODE_DIST_MIRROR='https://npmmirror.com/mirrors/node'

# go 镜像源
export GOPROXY='https://goproxy.cn'

# mcfly
export MCFLY_FUZZY=2
export MCFLY_RESULTS=25
