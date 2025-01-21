return {
    {
        "TD-Sky/fcitx.nvim",
        keys = {
            {
                "<leader>ux",
                "<cmd>FcitxToggleSwitch<CR>",
                desc = "开关输入法自动切换",
            },
        },
    },
    {
        "JuanZoran/Trans.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        build = function()
            require("Trans").install()
        end,
        keys = {
            { "gl", "<cmd>Translate<cr>", mode = { "n", "x" }, desc = "翻译" },
        },
        opts = {
            frontend = {
                default = {
                    animation = {
                        open = "fold",
                        close = "fold",
                    },
                },
                hover = {
                    width = 80,
                },
            },
        },
    },
    { "lambdalisue/suda.vim" },
}
