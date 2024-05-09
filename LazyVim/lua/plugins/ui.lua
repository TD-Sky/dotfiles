return {
    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 500,
            stages = "fade",
        },
    },
    {
        "TD-Sky/neo-rhythm",
        opts = {
            range = {
                start = { 7, 0 },
                ending = { 18, 30 },
            },
            day = {
                bg = "light",
            },
        },
    },
    {
        "folke/noice.nvim",
        opts = {
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                            { find = "%d lines? yanked" },
                            { find = "%d lines? changed" },
                            { find = "1 line less" },
                            { find = "%d fewer lines" },
                            { find = "%d more lines?" },
                            { find = "1 buffer wiped out" },
                            { find = "1 buffer deleted" },
                        },
                    },
                    view = "mini",
                },
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "gb", "<cmd>Gitsigns blame_line<cr>", desc = "git blame" },
        },
    },
    {
        "akinsho/toggleterm.nvim",
        enabled = false,
        keys = {
            { "<M-1>", "<cmd>ToggleTerm size=11 direction=horizontal<cr>", desc = "水平终端" },
            { "<M-2>", "<cmd>ToggleTerm size=50 direction=vertical<cr>", desc = "垂直终端" },
            { "<M-3>", "<cmd>ToggleTerm direction=float<cr>", desc = "浮动终端" },
        },
        config = true,
    },
    -- {
    --     "NeogitOrg/neogit",
    --     cmd = "Neogit",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-telescope/telescope.nvim",
    --         "sindrets/diffview.nvim",
    --     },
    --     keys = {
    --         { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    --     },
    --     config = true,
    -- },
}
