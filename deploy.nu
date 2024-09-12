#!/usr/bin/env nu

use std log

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
        neovide wezterm zellij yazi
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

def pfs [
    srcs: list<string>,
    dest: string,
] {
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
    let src = $src | path expand

    if $place {
        mkdir -v $dest
        log info $"($src) -> ($dest)"
        ln -s $src -t $dest
    } else {
        mkdir -v ($dest | path parse | get parent)
        log info $"($src) => ($dest)"
        ln -s $src $dest
    }
}

def deploy-dir [
    src: string,
    dest: path,
    place: bool,
] {
    let strip_prefix = if $place {
        {|p|
            $p
            | path relative-to (
                $src | path expand | path parse | get parent
        )}
    } else {
        {|p| $p | path relative-to ($src | path expand) }
    }

    let dirs = glob $"($src)/**/*" --no-file
        | each $strip_prefix

    mkdir -v ...(
        $dirs
        | each {|dir| $dest | path join $dir }
    )

    let files = glob $"($src)/**/*" --no-dir
        | each $strip_prefix

    $files
    | each {|file|
        let src = $file | path expand
        let dest = $dest | path join $file

        log info $"($src) => ($dest)"
        ln -s $src $dest
    }
}
