#!/usr/bin/env -S nu --stdin

const MANIFEST = {
    # 社交
    QQ: {
        packages: ["linuxqq-nt-bwrap"],
        manager: "paru"
    },
    telegram: {
        packages: ["telegram-desktop"],
        desc: "电报"
    },
    thunderbird: "电子邮件客户端",
    wechat: {
        packages: ["wechat-universal-bwrap"],
        manager: "paru",
        desc: "微信(沙盒)"
    },
    wemeet: {
        packages: ["wemeet-bin"],
        manager: "paru",
        desc: "腾讯会议(沙盒)"
    },
    feishu: {
        packages: ["feishu-portable"],
        manager: "paru",
        desc: "飞书(沙盒)"
    },

    # OS
    QEMU: {
        packages: ["qemu-full"]
    },
    ventoy: "制作镜像盘",
    podman: "容器运行时",
    buildah: "清理所有外部死容器",

    # kernel
    linux-headers: "内核头文件",
    vulkan-intel: "vulkan的intel驱动",
    sof-firmware: "声卡固件",
    pipewire: {
        packages: [
            "pipewire",
            "wireplumber",
            "pipewire-pulse",
            "pipewire-alsa",
            "pipewire-jack"
        ],
        desc: "音频系统"
    },

    # PL
    gdb: "GNU调试器",
    lldb: "LLVM调试器",
    mold: "现代链接器",
    wild: "rust链接器",
    rust-script: "rust脚本解释器",
    rustup: "管理rust工具链",
    tokei: "统计代码",
    gcc: "GNU的C/C++工具链",
    ast-grep: "匹配搜索 tree-sitter",
    cargo-binutils: {
        manager: "cargo",
        desc: "Rust二进制工具"
    },
    lua-language-server: "",
    stylua: "lua格式化器",
    tombi: "toml语言工具",
    shfmt: "bash/zsh格式化器",
    gopls: "Go语言服务器",
    yaml-language-server: {
        manager: "npm"
    },
    vscode-json-language-server: {
        manager: "npm",
        packages: ["vscode-langservers-extracted"]
    },
    volar: {
        manager: "npm",
        packages: ["@vue/language-server"]
    },
    biome: "前端格式化器",
    prettier: {
        manager: "npm",
        packages: ["prettier", "@prettier/plugin-xml"],
        desc: "前端格式化器"
    },
    mise: "管理语言工具链",
    bash-language-server: {
        manager: "npm"
    },
    sccache: "编译缓存",
    kondo: "扫除编译产物",
    clang: {
        packages: ["clang", "llvm"],
        desc: "C/C++工具链"
    },
    typescript: {
        manager: "npm",
        packages: ["typescript", "typescript-language-server"]
    },
    typst: {
        packages: ["typst", "tinymist", "typstyle"],
    },
    tree-sitter-cli: "安装tree-sitter解析器",
    uv: "python项目管理",
    ruff: "python格式化器",
    basedpyright: {
        manager: "uv",
        desc: "python语言服务器",
    },
    astro-ls: {
        manager: "npm",
        packages: ["@astrojs/language-server"]
        desc: "AstroJS的语言服务器",
    },

    # desktop
    qt-theme: {
        packages: ["qt6ct", "qt5ct", "kvantum"]
    },
    kitty: "最强终端模拟器",
    sddm: "会话管理器",
    fcitx: {
        packages: ["fcitx5-im", "fcitx5-chinese-addons", "fcitx5-pinyin-zhwiki"],
        desc: "小企鹅输入法"
    },
    zen-browser: "浏览器",
    chromium: "谷歌裸核浏览器",
    dbeaver: "PostgreSQL客户端",
    sqlitebrowser: "SQLite客户端",
    keepassxc: "keepass客户端",

    # kde
    dolphin: {
        packages: ["dolphin", "ffmpegthumbs", "kdegraphics-thumbnailers"],
        desc: "文件管理器"
    },
    spectacle: "截图",
    kcolorchooser: "颜色拾取",

    # wayland
    wl-clipboard: "剪贴板",
    cliphist: "剪贴板历史",
    nerd-fonts: "书呆子字体",
    noto-fonts: {
        packages: [
        "noto-fonts",
        "noto-fonts-emoji",
        "noto-fonts-extra",
        "noto-fonts-cjk"
        ],
        desc: "零豆腐块字体"
    },

    # shell
    nushell: "结构化shell",
    # mcfly: "历史命令",
    atuin: "历史命令",
    starship: "装饰提示符",
    zoxide: "瞬移",
    zellij: "终端复用器",
    bash-completion: "bash补全",
    zsh: {
        packages: ["zsh", "zsh-completions"],
        desc: "zsh及额外补全包"
    },

    # filesystem
    xdg-user-dirs: "规范目录",
    eza: "高级ls",
    rsync: "超级复制",
    parallel-disk-usage: "磁盘空间统计",
    yazi: {
        packages: ["yazi-git", "jq", "ffmpegthumbnailer", "unarchiver"],
        desc: "终端文件管理器"
    },
    gparted: "分区GUI",
    exfatprogs: "exfat格式化工具",
    conceal: {
        packages: ["conceal-bin"],
        manager: "paru",
        desc: "垃圾回收站"
    },
    kdiff3: "比较文件/目录",
    squashfs-tools: "高压缩率只读文件系统",

    # utility
    man: {
        packages: ["man-db", "man-pages"],
        desc: "手册"
    },
    less: "pager",
    bat: "高级cat",
    choose: "高级cut",
    dos2unix: "改变文本的平台",
    enca: "检查文件编码",
    fd: "搜索文件",
    jaq: "高级jq",
    jless: "json阅读器",
    ripgrep: "正则匹配行",
    ripgrep-all: "万能正则匹配行",
    sd: "高级sed",
    skim: "模糊搜索.rs",
    fzf: "模糊搜索.go",
    tree: "树视图",
    protobuf: "ProtocolBuffers",
    navi: "命令速查",
    pastel: "调色板",
    hyperfine: "竞争测试",
    pueue: "守护大任务",
    hexyl: "hex查看器",
    libtree: "程序的库依赖树视图",
    halp: "命令行选项标准化检验",

    # AI
    aichat: "LLM CLI",

    # git
    lazygit: "git TUI",
    difftastic: "语言diff",
    git-cliff: "变更日志生成器",
    gitoxide: "锈化git",
    git-filter-repo: "过滤git项目",

    # data
    7zip: "7z",
    unrar: "解压RAR",
    zip: {
        packages: ["zip", "unzip"]
    },
    qbittorrent: "下载种子",
    dufs: "文件服务器",

    # media
    imagemagick: "图片瑞士军刀",
    mpv: "看视频",
    yt-dlp: "下载Youtube视频",
    dagtoc: {
        packages: ["dagtoc-bin"],
        manager: "paru",
        desc: "操作PDF目录"
    },
    pandoc: {
        packages: ["pandoc-bin"],
        desc: "LaTex渲染器"
    },
    kid3-qt: "编辑音乐标签",
    espeak: {
        packages: ["espeak-ng"],
        desc: "电子朗读"
    },
    mupdf-tools: "PDF工具箱",
    gwenview: "看图",
    zathura: {
        packages: ["zathura", "zathura-pdf-mupdf"],
        desc: "PDF阅读器"
    },
    webp-pixbuf-loader: "GDK的webp支持",
    inkscape: "操作矢量图",
    poppler: "`pdftoppm -png`将PDF转成图片",
    wps: {
        packages: [
            "wps-office-cn-bwrap",
            "wps-office-mui-zh-cn",
            "ttf-wps-fonts",
            "wps-office-fonts"
        ],
        manager: "paru",
        desc: "WPS本体+中文语言包+符号字体+中文常用字体"
    },
    viu: "终端看图",

    # language
    pot-translation: "一站式翻译",
    didyoumean: {
        packages: ["didyoumean-bin"],
        manager: "paru",
        desc: "纠正英文单词"
    },
    pdf2zh: {
        manager: "uv",
        desc: "智能布局留存翻译PDF",
    },

    # monitor
    acpi: "电池信息",
    bandwhich: "监测网络带宽",
    bottom: "高级top",
    light: "调节亮度",
    procs: "查看进程",
    wiremix: "音量面板",
    dysk: "统计分区大小",
    erdtree: "体积伴随文件树",
    macchina: "系统信息",
    cyme: "查看USB设备",
    qpwgraph: "音频设备拓补图",

    # network
    gping: "图形化ping",
    traceroute: "路由显形",
    lsof: "监测端口",
    openssh: "ssh",
    xh: "人类友好的http客户端",
    rustscan: "扫描端口",

    # show
    asciinema: "录制命令行视频",
    screenkey: "按键回显",
    obs-studio: "流录制",

    # cargo
    cargo-shear: {
        manager: "cargo",
        desc: "检查无用依赖",
    },
    cargo-msrv: "最旧可用rustc版本",
    cargo-expand: "展开宏",
    cargo-edit: "编辑依赖",
    cargo-supply-chain: "依赖元信息",
    cargo-deny: "分析依赖",
    cargo-audit: {
        packages: ["cargo-audit", "cargo-auditable"],
        desc: "审计"
    },
    cargo-depgraph: "依赖图",
    cargo-update: "更新cargo安装的应用",
    cargo-cache: "管理缓存",
    cargo-zigbuild: "无痛链接指定版本glibc",
    cargo-wizard: "编译配置",
    cargo-binstall: "下载crate的二进制",
    cargo-get: {
        manager: "cargo",
        desc: "读取Cargo.toml信息"
    },
    cargo-workspace-unused-pub: {
        packages: ["https://github.com/cpg314/cargo-workspace-unused-pub.git"],
        manager: "cargo:src",
        desc: "检查工作空间未使用的pub项",
    },
    cargo-insta: "懒人测试",
    cargo-autoinherit: {
        manager: "cargo",
        desc: "一键收束工作空间下的依赖",
    },
    cargo-bloat: "查看依赖的空间占用情况",

    # arch
    nvrs: {
        manager: "paru",
        packages: ["nvrs-bin"],
        desc: "检查包版本",
    },
    pacman-contrib: "打包工具箱",
    aurpublish: "打包钩子",
    pacfiles: "搜索文件对应的包",

    # android
    android-tools: "安卓调试桥",
    jetbrains-toolbox: {
        manager: "paru",
        desc: "JB IDE 下载器"
    },
    uiautodev: {
        manager: "uv",
        desc: "安卓控件树查看器",
    },
    waydroid: "安卓模拟器",

    # unknown
    genact: "Linux领域大神",
}

def main [] {
    let manifest = $MANIFEST
        | items {|k, v|
            if ($v | describe) == 'string' {
                {
                    name: $k,
                    desc: $v,
                }
            } else {
                {
                    name: $k,
                    ...$v
                }
            }
        }

    let paru = try { which paru | get 0 | get path }
    let cargo = try { which cargo | get 0 | get path }
    let cargo_bin = try { which cargo-binstall | get 0 | get path }
    let npm = try { which npm | get 0 | get path }
    let uv = try { which uv | get 0 | get path }

    mut tbl = {
        pacman: [],
        paru: [],
        cargo: [],
        'cargo:src': [],
        npm: [],
        uv: [],
    }
    for it in $manifest {
        let packages = $it.packages? | default [$it.name]
        let mgr = $it.manager? | default 'pacman'

        let subtbl = $tbl | get $mgr | append $packages
        $tbl = $tbl | upsert $mgr $subtbl
    }

    try {
        if $paru != null {
            paru -Sy --needed ...$tbl.pacman ...$tbl.paru
        } else {
            pacman -Sy --needed ...$tbl.pacman
        }
    }

    try {
        if $npm != null {
            npm install -g ...$tbl.npm
        }
    }

    try {
        if $cargo_bin != null {
            cargo binstall ...$tbl.cargo
        }
    }

    if $cargo != null {
        for p in $tbl.'cargo:src' {
            try {
                cargo install --git $p
            }
        }
    }

    if $uv != null {
        for p in $tbl.uv {
            try {
                uv tool install $p
            }
        }
    }
}
