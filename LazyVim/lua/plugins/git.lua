return {
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "gb", "<cmd>Gitsigns blame_line<cr>", desc = "git blame" },
        },
    },
    {
        "sindrets/diffview.nvim",
        config = true,
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "diff" },
            { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "文件历史" },
            { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "当前文件历史" },
        },
    },
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>gb",
                function()
                    Snacks.gitbrowse()
                end,
                desc = "跳转到远程仓库相应位置",
            },
        },
    },
}
