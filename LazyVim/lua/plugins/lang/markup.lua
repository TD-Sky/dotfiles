return {
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = "markdown",
        keys = {
            { "<leader>cp", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "预览" },
        },
        config = function()
            vim.g.mkdp_auto_start = 1
        end,
    },
    {
        "lervag/vimtex",
        enabled = false,
        ft = "tex",
        config = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_view_general_viewer = "zathura"
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_latexmk = { continuous = 0, callback = 0 }
        end,
    },
}
