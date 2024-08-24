return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "nushell/tree-sitter-nu" },
        opts = {
            -- stylua: ignore
            ensure_installed = {
                "rust", "slint",
                "go", "gomod",
                "python", "ruby", "perl",
                "bash", "fish", "nu",
                "c","cpp", "cmake",
                "scheme", "haskell",
                "html", "vue",
                "css", "scss",
                "javascript", "typescript",
                "java", "kotlin",
                "json", "json5", "jsonc",
                "latex", "bibtex",
                "markdown", "markdown_inline",
                "typst", "dot",
                "toml", "yaml", "kdl", "ron",
                "vim", "comment",
            },
            highlight = {
                enable = true,
                disable = function(_, buf)
                    return vim.bo[buf].filetype == "bigfile" or vim.g.vscode
                end,
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            max_lines = 1,
        },
    },
    {
        "nkrkv/nvim-treesitter-rescript",
        enabled = false,
        ft = "rescript",
    },
    {
        "rayliwell/tree-sitter-rstml",
        enabled = false,
        ft = "rust",
        dependencies = { "nvim-treesitter" },
        build = ":TSUpdate",
        config = true,
    },
}
