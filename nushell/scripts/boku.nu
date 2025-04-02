#!/usr/bin/env -S nu --stdin

# Filters by `characters`
export def chars [...chars: string] {
    $in | where ($it.characters | list contains $chars)
}

# Filters by `tags`
export def tags [...tags: string] {
    $in | where ($it.tags | list contains $tags)
}

# Aggregates books into human-readable table
export def agg [
    --share (-s),
] {
    $in
    | each {|it|
        let book = if $share {
            $"[($it.author)] ($it.name)"
        } else {
            book fmt $it
        }

        {
            id: $it.id,
            book: $book,
        }
    }
    | table --theme basic
    | bat -p
}

# Records a new book
export def rec [
    --toc: string = "./boku.json", # Book indices
    book: string, # Rename this directory to allocated ID
] {
    let btoc = open $toc

    let title = (input '标题：')
    let info = $title | parse '[{author}]{rest}' | first
    let author = $info.author | str trim
    let name = $info.rest
        | str split-once '('
        | option or-else {|| $info.rest | str split-once '[' }
        | option map {|p| $p.0 | str trim }
        | default $info.rest

    let series = $btoc
        | get series
        | filter {|it| $it | is-not-empty }
        | uniq
        | prepend '<新建>'
        | pick --prompt '分类：' --ansi --cycle
        | match $in {
            '<新建>' => {
                input '分类：'
            }
            '' => { null }
            $series => {
                print $"分类：($series)"
                $series
            }
        }

    mut chars = []
    if ($series | is-not-empty) {
        let choices = $btoc
            | where series == $series
            | get characters
            | filter {|it| $it | is-not-empty }
            | flatten
            | uniq
            | pickm --prompt '角色：' --ansi --cycle --bind 'ctrl-a:select-all,ctrl-r:toggle-all'
        $chars = $chars | append $choices

        let extra = (input '新角色：' | split words)
        $chars =  $chars | append $extra

        print $"角色：($chars | str join ', ')"
    }

    mut tags = []
    let choices = $btoc
        | get tags
        | filter {|it| $it | is-not-empty }
        | flatten
        | uniq
        | pickm --prompt '要素：' --ansi --cycle --bind 'ctrl-a:select-all,ctrl-r:toggle-all'
    $tags = $tags | append $choices

    let extra = (input '新要素：' | split words)
    $tags =  $tags | append $extra

    print $"要素：($tags | str join ', ')"

    (rec-impl
        --toc $toc
        --author $author
        --name $name
        --series ($series | default -e null)
        --chars ($chars | default -e null)
        --tags ($tags | default -e null)
        $book)
}

def rec-impl [
    --toc: string, # Book indices
    --author (-a): string,
    --name (-n): string,
    --series (-s): string,
    --chars (-c): list<string>,
    --tags (-t): list<string>,
    book: string, # Rename this directory to allocated ID
] {
    let id = (random uuid)
    let info = {
        id: $id,
        author: $author,
        name: $name,
        series: $series,
        characters: $chars,
        tags: $tags,
        pages: (ls $book | length),
    }
    print {
        id: $id,
        info: (book fmt $info),
    }

    mv -i $book $id

    open $toc
    | append $info
    | collect { save -f $toc }
}


def 'option map' [f: closure] {
    let self = $in
    if not ($self | is-empty) {
        do $f $self
    } else {
        null
    }
}

def 'option or-else' [f: closure] {
    let self = $in
    if not ($self | is-empty) {
        $self
    } else {
        do $f
    }
}

def 'book fmt' [bk: record] {
    [
        $bk.name,
        ("作者：" + $bk.author),
        ($bk.series | option map {|it| '系列：' + $it }),
        ($bk.characters | default [] | str join ', ' | option map {|it| '角色：' + $it }),
        ($bk.tags | default [] | str join ',' | option map {|it| '要素：' + $it }),
        ("页数：" + $bk.pages),
    ]
    | filter {|it| $it != null }
    | str join (char newline)
}

def 'list contains' [list: list<string>] {
    let self = $in | default []

    for dest in $list {
        for elt in $self {
            if $elt =~ $dest {
                return true
            }
        }
    }

    false
}

def --wrapped 'pick' [...rest]: list -> string {
    $in
    | str join (char newline)
    | fzf ...$rest
}

def --wrapped 'pickm' [...rest]: list -> list {
    $in
    | str join (char newline)
    | fzf --multi ...$rest
    | split row (char newline)
    | filter {|it| $it | is-not-empty }
}

def 'str split-once' [delimiter: string]: string -> list {
    let self = $in

    let i = $self | str index-of $delimiter
    if $i < 0 {
        return null
    }

    let left = $self | str substring ..<$i
    let right = $self | str substring ($i + 1)..
    [$left, $right]
}
