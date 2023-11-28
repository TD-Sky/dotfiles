return {
    { "elkowar/yuck.vim", ft = "yuck" },
    {
        "eraserhd/parinfer-rust",
        enabled = false,
        ft = {
            "clojure",
            "lisp",
            "scheme",
            "racket",
            "yuck",
        },
        build = "cargo build --release",
    },
}
