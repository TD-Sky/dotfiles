return {
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
        "nvim-focus/focus.nvim",
        config = true,
    },
    {
        "folke/snacks.nvim",
        keys = {
            -- git
            { "<leader>gb", false },
            { "<leader>gl", false },
            { "<leader>gL", false },
            { "<leader>gs", false },
            { "<leader>gS", false },
            { "<leader>gd", false },
            { "<leader>gf", false },
        },
        opts = function(_, opts)
            -- scroll
            opts.scroll = { enabled = false }

            -- image
            opts.image = { enabled = true }

            -- dashboard
            local projects = {
                icon = " ",
                key = "p",
                desc = " Projects",
                action = "<cmd>Telescope neovim-project history<CR>",
            }

            table.insert(opts.dashboard.preset.keys, 3, projects)
        end,
    },
}
