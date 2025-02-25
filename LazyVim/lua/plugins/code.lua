local utils = require("utils")

return {
    {
        "nvimdev/guard.nvim",
        dependencies = {
            "nvimdev/guard-collection",
        },
        keys = {
            { "<leader>lf", "<cmd>Guard fmt<cr>", desc = "异步格式化" },
        },
        opts = {
            lua = {
                cmd = "stylua",
                args = { "--indent-type", "Spaces", "-" },
                stdin = true,
            },
            python = "ruff",
            toml = "taplo",
            -- ocaml = {
            --     cmd = "ocamlformat",
            --     args = {
            --         "--enable-outside-detected-project",
            --         "--name",
            --         utils.vim.current_buffer_name(),
            --         "-",
            --     },
            --     stdin = true,
            -- },
            sh = {
                cmd = "shfmt",
                args = { "-i", "4" },
                stdin = true,
            },
            ["c,cpp"] = {
                cmd = "clang-format",
                args = {
                    "--style",
                    "{IndentWidth: 4}",
                },
                stdin = true,
            },
            rust = {
                cmd = "rustfmt",
                args = { "--edition", "2024", "--emit", "stdout" },
                stdin = true,
            },
            go = "gofmt",
            ["vue,json,javascript,typescript,xml,yaml,html,css,astro"] = "prettier",
            ["jsonc,json5"] = {
                cmd = "prettier",
                args = { "--trailing-comma", "none", "--stdin-filepath" },
                fname = true,
                stdin = true,
            },
            typst = {
                cmd = "typstyle",
                stdin = true,
            },
        },
        config = function(_, opts)
            local ft = require("guard.filetype")

            for lang, opt in pairs(opts) do
                ft(lang):fmt(opt)
            end

            vim.g.guard_config = {
                fmt_on_save = false,
            }
        end,
    },
    {
        "folke/todo-comments.nvim",
        keys = {
            { "[t", false },
            { "]t", false },
        },
    },
    {
        "numToStr/Comment.nvim",
        config = true,
    },
    {
        "saghen/blink.cmp",
        dependencies = { "xzbdmw/colorful-menu.nvim" },
        event = "InsertEnter",
        opts = {
            completion = {
                trigger = {
                    show_on_x_blocked_trigger_characters = { "'", '"', "(", "{", "=" },
                },
                menu = {
                    border = "rounded",
                    draw = {
                        columns = {
                            { "kind_icon" },
                            {
                                "label",
                                gap = 1,
                            },
                        },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
                documentation = {
                    update_delay_ms = 0,
                    auto_show_delay_ms = 0,
                    window = {
                        border = "rounded",
                    },
                },
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = true,
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
        },
    },
}
