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

def 'book fmt' [bk: record] {
    [
        $bk.name,
        ("作者：" + $bk.author),
        ($bk.series | option map {|it| '系列：' + $it }),
        ($bk.characters | default [] | str join ', ' | option map {|it| '角色：' + $it }),
        ($bk.tags | default [] | str join ',' | option map {|it| '要素：' + $it }),
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
