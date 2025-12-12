# MISC #

$env.config.show_banner = false

# VARIABLE #

$env.path ++= [
    "~/.cargo/bin",
    "~/.local/bin",
]

load-env {
    EDITOR: 'lvim',
    VISUAL: 'lvim',

    LESS: '--quit-if-one-screen --RAW-CONTROL-CHARS --chop-long-lines',

    FZF_DEFAULT_OPTS: '--ansi --height=60% --reverse --cycle',

    MANPAGER: 'sh -c "col -bx | bat -pl man --theme=Monokai\ Extended"',
    MANROFFOPT: '-c',

    MOLD_JOBS: 1,

    LOCALE_ARCHIVE: /usr/lib/locale/locale-archive, # see https://nixos.wiki/wiki/Locales

    RUSTUP_DIST_SERVER: "https://rsproxy.cn", # affect `rustup update`
    RUSTUP_UPDATE_ROOT: "https://rsproxy.cn/rustup", # affect `rustup self-update`
    RUST_BACKTRACE: 1,

    # XDG
    XDG_CONFIG_HOME: $"($env.HOME)/.config",
    XDG_CACHE_HOME: $"($env.HOME)/.cache",
    XDG_DATA_HOME: $"($env.HOME)/.local/share",
    XDG_STATE_HOME: $"($env.HOME)/.local/state",
}

# INTEGRATION #
mkdir $"($nu.cache-dir)"

# carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
carapace _carapace nushell | save -f $"($nu.cache-dir)/carapace.nu"

zoxide init nushell | save -f $"($nu.cache-dir)/zoxide.nu"
navi widget nushell | save -f $"($nu.cache-dir)/navi.nu"
# mise activate nu | save -f $"($nu.cache-dir)/mise.nu"
