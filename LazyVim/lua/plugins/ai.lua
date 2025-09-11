return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            opts = {
                log_level = "DEBUG",
                language = "Chinese",
            },
            strategies = {
                chat = {
                    adapter = "deepseek",
                    keymaps = {
                        send = {
                            modes = {
                                n = "<C-CR>",
                                i = "<C-CR>",
                            },
                        },
                    },
                },
            },
        },
    },
}
