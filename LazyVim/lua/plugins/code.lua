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
            fmt = {
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
                ["json,jsonc,json5,javascript,typescript,javascriptreact,typescriptreact,css"] = {
                    cmd = "biome",
                    args = { "format", "--indent-style=space", "--stdin-file-path" },
                    fname = true,
                    stdin = true,
                },
                ["vue,xml,yaml,html,astro"] = "prettier",
                typst = {
                    cmd = "typstyle",
                    stdin = true,
                },
                kotlin = {
                    cmd = "ktfmt",
                    args = { "--kotlinlang-style", "-" },
                    stdin = true,
                },
            },
            lint = {
                typos = "c,cpp,rust,go,python,lua",
            },
        },
        config = function(_, opts)
            local ft = require("guard.filetype")

            for lang, opt in pairs(opts.fmt) do
                local f = ft(lang):fmt(opt)

                if opts.lint.typos:find(lang) then
                    f:lint("typos")
                end
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
            sources = {
                providers = {
                    buffer = {
                        opts = {
                            -- get all buffers, even ones like neo-tree
                            get_bufnrs = vim.api.nvim_list_bufs,
                        },
                    },
                },
            },
            completion = {
                accept = {
                    auto_brackets = {
                        enabled = false,
                    },
                },
                trigger = {
                    show_on_x_blocked_trigger_characters = { "'", '"', "(", "{", "=" },
                },
                menu = {
                    border = "rounded",
                    winblend = 10,
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
                    update_delay_ms = 50,
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
    {
        "nvim-neotest/neotest",
        opts = function()
            return {
                adapters = {
                    require("rustaceanvim.neotest"),
                },
            }
        end,
    },
    {
        "mistricky/codesnap.nvim",
        build = "make build_generator",
        keys = {
            {
                "<leader>cs",
                "<cmd>CodeSnap<cr>",
                mode = { "x" },
                desc = "Save selected code snapshot into clipboard",
            },
            {
                "<leader>ca",
                "<cmd>CodeSnapASCII<cr>",
                mode = { "x" },
                desc = "Save selected code ASCII snapshot into clipboard",
            },
        },
        opts = {
            mac_window_bar = false,
            bg_x_padding = 10,
            bg_y_padding = 10,
            has_line_number = true,
        },
    },
}
