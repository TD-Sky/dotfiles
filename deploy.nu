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
        pip.conf ghc fontconfig macchina paru
        uv mise
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
] {
    let self = $in

    $self
    | append {
        src: $src,
        dest: $dest,
        place: $target,
    }
}

def pfs [srcs: list<string>, dest: string] {
    let self = $in

    $srcs
    | reduce --fold $self {|src, self|
        $self
        | append {
            src: $src,
            dest: $dest,
            place: true,
        }
    }
}

def deploy-item [it: record] {
    let dest = $it.dest | path expand

    match ($it.src | path type) {
        file => { deploy-file $it.src $dest $it.place },
        dir if $it.place => { place-dir $it.src $dest },
        dir => { deploy-dir $it.src $dest },
    }
}

def deploy-file [
    src: string,
    dest: path,
    place: bool,
] {
    let dest = if $place {
        mkdir -v $dest
        $dest | path join ($src | path basename)
    } else {
        mkdir -v ($dest | path dirname)
        $dest
    }

    link $src $dest
}

def deploy-dir [
    src: string,
    dest: path,
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
        link $file $dest
    }
}

def place-dir [src: string, dest: path] {
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
        link $file $dest
    }
}

def link [src: string, dest: path] {
    let srcp = pwd | path join $src

    if not (is-linked $srcp $dest) {
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

def 'path strip' [...prefix: string]: string -> path {
    $in | path relative-to ($prefix | path join)
}
