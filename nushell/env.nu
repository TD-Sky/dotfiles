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

ssh-agent -c
    | lines
    | first 2
    | parse "setenv {name} {value};"
    | transpose -r
    | into record
    | load-env

# INTEGRATION #
mkdir $"($nu.cache-dir)"

# carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
carapace _carapace nushell | save -f $"($nu.cache-dir)/carapace.nu"

zoxide init nushell | save -f $"($nu.cache-dir)/zoxide.nu"
navi widget nushell | save -f $"($nu.cache-dir)/navi.nu"
atuin init nu | save -f $"($nu.cache-dir)/atuin.nu"
mise activate nu | save -f $"($nu.cache-dir)/mise.nu"

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

def 'option map' [f: closure] {
    match $in {
        null => { null }
        $v => { do $f $v }
    }
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
                let v = jj workspace root --ignore-working-copy
                    | complete
                    | match ($in.stdout | str trim) {
                        "" => { pwd | str replace -r $"^($env.HOME)" '~' }
                        $v => {
                            [($v | path basename), (pwd | path relative-to $v)]
                            | path join
                            | str trim -r -c '/'
                        }
                    }

                let c1 = {
                    fg: 'black',
                }
                let c2 = {
                    fg: '#FFBF00',
                    bg: 'black',
                }
                let c3 = {
                    fg: 'black',
                    bg: '#FFBF00',
                }
                let c4 = {
                    fg: '#FFBF00',
                }

                $"(ansi -e $c1)(ansi -e $c2)  ($v) (ansi -e $c3)(ansi reset)(ansi -e $c4)▓▒░(ansi reset)"
            }
            {
                jj log --ignore-working-copy --no-graph --limit 1 --color always --revisions @ -T 'format_short_change_id_with_change_offset(self)'
                | complete
                | get stdout
            }
            {
                jj log --ignore-working-copy --no-graph --limit 1 --color always --revisions @ -T 'commit_id.shortest(8)'
                | complete
                | map stdout {|v| $" ($v)" }
            }
            {
                jj log --ignore-working-copy --no-graph --limit 1 --color always -r "closest_bookmark(@)" -T 'bookmarks.join(" ")'
                | complete
                | map stdout {|v| $"󰘬 ($v)" }
            }
            {
                jj log --ignore-working-copy --no-graph --color never -r "closest_bookmark(@)..@" -T 'change_id ++ "\n"'
                | complete
                | map stdout {|v| $" ($v | lines | length)" }
            }
            {
                jj log --ignore-working-copy --no-graph --color never --revisions @ -T 'self.diff("root-glob:**/*").files().map(|f| f.status())'
                | complete
                | map stdout {|v|
                    let v = $v
                        | split words
                        | group-by

                    [
                        ($v.modified? | option map {|v| $"󰤌 ($v | length)"}),
                        ($v.added? | option map {|v| $" ($v | length)"}),
                        ($v.removed? | option map {|v| $"󰗨 ($v | length)"}),
                        ($v.renamed? | option map {|v| $" ($v | length)"}),
                    ]
                    | where {|v| $v | is-not-empty }
                    | str join ' '
                }
            }
            {
                jj log --ignore-working-copy --no-graph --limit 1 --color always --revisions @ -T 'prompt'
                | complete
                | get stdout
            }
            (char newline)
        ]
        | render-modules
    },
    PROMPT_COMMAND_RIGHT: {
        [
            { cargo get 'package.version' | complete | map stdout {|v| $"󰏗 ($v)" } }
            {
                let c1 = {
                    fg: 'white',
                }
                let c2 = {
                    fg: 'black',
                    bg: 'white',
                }

                $"(ansi -e $c1)░▒▓(ansi -e $c2) (date now | format date '%Y-%m-%d %H:%M:%S') (ansi reset)"
            }
        ]
        | render-modules
    }
}
