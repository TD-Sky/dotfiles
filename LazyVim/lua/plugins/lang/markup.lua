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
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            code = {
                sign = false,
                width = "block",
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = {},
            },
        },
        ft = { "markdown", "norg", "rmd", "org" },
        config = function(_, opts)
            require("render-markdown").setup(opts)
            Snacks.toggle({
                name = "Render Markdown",
                get = function()
                    return require("render-markdown.state").enabled
                end,
                set = function(enabled)
                    local m = require("render-markdown")
                    if enabled then
                        m.enable()
                    else
                        m.disable()
                    end
                end,
            }):map("<leader>um")
        end,
    },
}
