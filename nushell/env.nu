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

# PROMPT #

def render-modules []: list -> string {
    $in
    | par-each --keep-order {|it|
        match ($it | describe) {
            "closure" => {
                try { do $it } catch { "" }
            }
            _ => { $it }
        }
    }
    | where {|v| $v != "" }
    | str join ' '
}

def 'map stdout' [f: closure]: record -> string {
    match $in.stdout {
        "" => { "" }
        $v => { do $f ($v | str trim) }
    }
}

load-env {
    PROMPT_COMMAND: {
        [
            {
                jj workspace root --ignore-working-copy
                    | complete
                    | match ($in.stdout | str trim) {
                        "" => { pwd }
                        $v => {
                            ['...', ($v | path basename), (pwd | path relative-to $v)]
                            | path join
                            | str trim -r -c '/'
                        }
                    }
            }
            {
                jj log --ignore-working-copy --no-graph --limit 1 --color always --revisions @ -T 'prompt'
                | complete
                | get stdout
            }
            {
                jj log --ignore-working-copy --no-graph --limit 1 --color always -r "closest_bookmark(@)" -T 'bookmarks.join(" ")'
                | complete
                | get stdout
            }
            {
                jj log --ignore-working-copy --no-graph --color never -r "closest_bookmark(@)..@" -T 'change_id ++ "\n"'
                | complete
                | map stdout {|v| $v | lines | length }
            }
            {
                jj log --ignore-working-copy --no-graph --color never --revisions @ -T 'self.diff("root-glob:**/*").files().map(|f| f.status()).join("\n")'
                | complete
                | map stdout {|v|
                    $v
                    | lines
                    | group-by
                    | items {|status, s|
                        $"($status)[($s | length)]"
                    }
                    | str join ' '
                }
            }
            (char newline)
        ]
        | render-modules
    },
    PROMPT_COMMAND_RIGHT: {
        [
            { cargo get 'package.version' | complete | map stdout {|v| $"crate[($v)]" } },
            $"(date now | format date '%Y-%m-%d %H:%M:%S')",
        ]
        | render-modules
    }
}
