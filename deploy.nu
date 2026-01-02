#!/usr/bin/env -S nu --stdin

use std/log
use std/iter

def main [] {
    []
    | pf navi ~/.local/share/navi/cheats
    | pf zsh/zshenv ~/.zshenv
    | pf zsh/zshrc ~/.config/zsh/.zshrc
    | pf zsh/p10k.zsh -t ~/.config/zsh
    | pf waybar/config.jsonc ~/.config/waybar/config
    | pf waybar/style.css -t ~/.config/waybar
    | pf kde ~/.config
    | pf bin -t ~/.local
    | pf cargo ~/.cargo
    | pf Templates -t ~
    | pfs [
        starship.toml fish nushell rofi mimeapps.list
        awesome swaylock plasma-workspace LazyVim
        neovide wezterm zellij yazi git
        git-cliff gitui zathura mpv gdb
        pip ghc fontconfig macchina paru
        uv mise atuin kitty jj zed opencode
        niri mako
    ] ~/.config
    | pfs [memo applications] ~/.local/share
    | each {|it| deploy-item $it }

    return
}

def 'main root' [] {
    for src in (ls root | get name) {
        cp -r $src  /
    }
}

# prepare
def pf [
    src: string,
    --target (-t),
    dest: string,
    --hard,
] {
    let self = $in

    $self
    | append {
        src: $src,
        dest: $dest,
        place: $target,
        hard: $hard,
    }
}

def pfs [
    srcs: list<string>,
    dest: string,
    --hard,
] {
    let self = $in

    $srcs
    | reduce --fold $self {|src, self|
        $self
        | append {
            src: $src,
            dest: $dest,
            place: true,
            hard: $hard,
        }
    }
}

def deploy-item [it: record] {
    let dest = $it.dest | path expand

    match ($it.src | path type) {
        file => {
            deploy-file $it.src $dest --place=$it.place --hard=$it.hard
        },
        dir if $it.place => {
            place-dir $it.src $dest --hard=$it.hard
        },
        dir => {
            deploy-dir $it.src $dest --hard=$it.hard
        },
    }
}

def deploy-file [
    src: string,
    dest: path,
    --place,
    --hard,
] {
    let dest = if $place {
        mkdir -v $dest
        $dest | path join ($src | path basename)
    } else {
        mkdir -v ($dest | path dirname)
        $dest
    }

    link $src $dest --hard=$hard
}

def deploy-dir [
    src: string,
    dest: path,
    --hard,
] {
    let dest_path = {|p|
        $dest
        | path join (
            $p
            | path strip (pwd) $src
        )
    }

    let dirs = glob $"($src)/**/*" --no-file
        | skip 1
        | each $dest_path

    # 确保dirs为空时也创建dest
    mkdir -v $dest ...$dirs

    glob $"($src)/**/*" --no-dir
    | each {|file|
        let dest = (do $dest_path $file)
        let file = $file | path strip (pwd)
        link $file $dest --hard=$hard
    }
}

def place-dir [
    src: string,
    dest: path,
    --hard,
] {
    let dest_path = {|p|
        $dest
        | path join (
            $p
            | path strip (pwd) ($src | path dirname)
        )
    }

    let dirs = glob $"($src)/**/*" --no-file
        | each $dest_path

    mkdir -v ...$dirs

    glob $"($src)/**/*" --no-dir
    | each {|file|
        let dest = (do $dest_path $file)
        let file = $file | path strip (pwd)
        link $file $dest --hard=$hard
    }
}

def link [
    src: string,
    dest: path,
    --hard,
] {
    let srcp = pwd | path join $src

    if $hard {
        if not (is-hard-linked $srcp $dest) {
            log info $"($src) => ($dest)"
            ln $srcp $dest
        }
    } else if not (is-linked $srcp $dest) {
        log info $"($src) => ($dest)"
        ln -s $srcp $dest
    }

}

def is-linked [src: path, dest: path]: nothing -> bool {
    try {
        $src == (realpath $dest)
    } catch {
        false
    }
}

def is-hard-linked [src: path, dest: path]: nothing -> bool {
    let f = {|p| stat --printf %i $p err> /dev/null }
    try {
        (do $f $src) == (do $f $dest)
    } catch {
        false
    }
}

def 'path strip' [...prefix: string]: string -> path {
    $in | path relative-to ($prefix | path join)
}
