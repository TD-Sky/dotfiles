#!/usr/bin/env nu

use std log
use std iter

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
        awesome hypr swaylock plasma-workspace LazyVim
        neovide wezterm zellij yazi git
        git-cliff gitui zathura mpv gdb
        pip.conf ghc fontconfig macchina paru
    ] ~/.config
    | pfs [memo applications] ~/.local/share
    | each {|it| deploy-item $it }

    return
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
        dir => { deploy-dir $it.src $dest $it.place },
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
    place: bool,
] {
    let strip_prefix = {|p|
        $p | path relative-to (pwd)
    }

    let join_suffix = if $place {
        {|p| $dest | path join $p }
    } else {
        {|p|
            $dest
            | path join ($p | str split-once).1
        }
    }

    let dirs = glob $"($src)/**/*" --no-file
        | each $strip_prefix

    try {
        mkdir -v ...($dirs | each $join_suffix)
    }

    let files = glob $"($src)/**/*" --no-dir
        | each $strip_prefix

    $files
    | each {|file|
        let dest = do $join_suffix $file
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

def is-linked [src: path, dest: path] {
    try {
        $src == (realpath $dest)
    } catch {
        false
    }
}

def 'str split-once' [] -> list {
    let s = $in

    let i = $s
    | split chars
    | iter find-index {|c| $c == '/' }

    if $i >= 0 {
        [
            ($s | str substring ..<$i),
            ($s | str substring ($i + 1)..),
        ]
    } else {
        null
    }
}
