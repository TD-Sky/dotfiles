return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            -- stylua: ignore
            ensure_installed = {
                "rust", "slint",
                "go", "gomod",
                "python", "bash", "perl", "fish",
                "c","cpp", "cmake",
                "scheme", "haskell",
                "html", "vue",
                "css", "scss",
                "javascript", "typescript",
                "java", "kotlin",
                "json", "json5", "jsonc",
                "latex", "bibtex",
                "markdown", "markdown_inline", "dot",
                "toml", "yaml", "kdl", "ron",
                "vim", "comment",
            },
            highlight = {
                enable = true,
                disable = function(_, buf)
                    return vim.api.nvim_buf_line_count(buf) > 5000 or vim.g.vscode
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
    { "nkrkv/nvim-treesitter-rescript", ft = "rescript" },
}
