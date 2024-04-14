return {
    {
        "TD-Sky/fcitx.nvim",
        ft = { "markdown", "typst" },
        keys = {
            {
                "<leader>ux",
                "<cmd>FcitxEnableSwitch<CR>",
                desc = "开启输入法自动切换",
            },
            {
                "<leader>uX",
                "<cmd>FcitxDisableSwitch<CR>",
                desc = "关闭输入法自动切换",
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
            { "gl", "<cmd>Translate<cr>", mode = { "n", "x" }, desc = " Translate" },
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
