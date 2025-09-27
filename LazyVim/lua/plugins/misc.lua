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
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>ft",
                function()
                    Snacks.terminal()
                end,
                desc = "Terminal (cwd)",
            },
            {
                "<leader>fT",
                function()
                    Snacks.terminal(nil, { cwd = require("lazyvim.util").root.get() })
                end,
                desc = "Terminal (Root Dir)",
            },
            {
                "<c-/>",
                function()
                    Snacks.terminal()
                end,
                desc = "Terminal (cwd)",
            },
            -- git
            { "<leader>gb", false },
            { "<leader>gl", false },
            { "<leader>gL", false },
            { "<leader>gs", false },
            { "<leader>gS", false },
            { "<leader>gd", false },
            -- LSP
            {
                "gd",
                function()
                    Snacks.picker.lsp_definitions()
                end,
                desc = "Goto Definition",
            },
            {
                "gr",
                function()
                    Snacks.picker.lsp_references()
                end,
                nowait = true,
                desc = "References",
            },
            {
                "gI",
                function()
                    Snacks.picker.lsp_implementations()
                end,
                desc = "Goto Implementation",
            },
            {
                "gD",
                function()
                    Snacks.picker.lsp_type_definitions()
                end,
                desc = "Goto Type Definition",
            },
        },
        opts = function(_, opts)
            -- scroll
            opts.scroll = { enabled = false }

            -- image
            opts.image = { enabled = true }

            -- dashboard
            opts.dashboard.preset.keys[1].action = "<leader>ff"
            opts.dashboard.preset.keys[3] = {
                icon = " ",
                key = "p",
                desc = "Projects",
                action = "<cmd>NeovimProjectHistory<CR>",
            }
            opts.dashboard.preset.keys[1].action = "<leader>fF"
            table.insert(opts.dashboard.preset.keys, 2, {
                icon = "",
                key = "F",
                desc = "Find Files (Root dir)",
                action = "<leader>ff",
            })

            -- zen
            opts.zen = {
                toggles = {
                    dim = false,
                    git_signs = true,
                },
            }

            -- styles
            opts.styles = {
                zen = {
                    backdrop = {
                        transparent = false,
                        blend = 99,
                    },
                },
            }
        end,
    },
}
