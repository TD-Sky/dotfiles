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
                toml = "tombi",
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
                typst = "typstyle",
                kotlin = {
                    cmd = "ktfmt",
                    args = { "--kotlinlang-style", "-" },
                    stdin = true,
                },
                d2 = {
                    cmd = "d2",
                    args = { "fmt", "-" },
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

                if vim.g.project_config ~= nil and vim.g.project_config.guard_on_fmt ~= nil then
                    vim.g.project_config.guard_on_fmt(lang, f)
                end

                if opts.lint.typos:find(lang) then
                    f:lint("typos")
                end
            end

            vim.g.guard_config = {
                fmt_on_save = false,
                always_save = true,
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
        dependencies = {
            "xzbdmw/colorful-menu.nvim",
            {
                "bydlw98/blink-cmp-env",
                lazy = true,
            },
            {
                "mikavilpas/blink-ripgrep.nvim",
                lazy = true,
            },
            -- {
            --     "Kaiser-Yang/blink-cmp-dictionary",
            --     dependencies = { "nvim-lua/plenary.nvim" },
            --     lazy = true,
            -- },
        },
        event = "InsertEnter",
        opts = {
            snippets = {
                preset = "luasnip",
            },
            sources = {
                default = function()
                    local default = { "lsp", "path", "snippets", "buffer", "ripgrep" }
                    if vim.tbl_contains({ "bash", "sh", "zsh", "nu" }, vim.bo.ft) then
                        table.insert(default, "env")
                    end
                    return default
                end,
                providers = {
                    lsp = {
                        fallbacks = {},
                        score_offset = 0,
                    },
                    snippets = {
                        score_offset = 0,
                        fallbacks = {},
                    },
                    path = {
                        score_offset = 3,
                    },
                    buffer = {
                        opts = {
                            -- get all buffers, even ones like neo-tree
                            get_bufnrs = vim.api.nvim_list_bufs,
                        },
                        fallbacks = {},
                    },
                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                        min_keyword_length = 5,
                        ---@module "blink-ripgrep"
                        ---@type blink-ripgrep.Options
                        opts = {
                            prefix_min_len = 5,
                            backend = {
                                context_size = 5,
                                ripgrep = {
                                    max_filesize = "1M",
                                    search_casing = "--smart-case",
                                },
                            },
                        },
                    },
                    -- dictionary = {
                    --     min_keyword_length = 4,
                    --     name = "Dict",
                    --     module = "blink-cmp-dictionary",
                    --     ---@module "blink-cmp-dictionary"
                    --     ---@type blink-cmp-dictionary.Options
                    --     opts = {
                    --         dictionary_files = {
                    --             vim.fn.stdpath("data") .. "/lazy/Trans.nvim/neovim.dict",
                    --         },
                    --         get_documentation = function(item)
                    --             return {
                    --                 get_command = "sqlite3",
                    --                 get_command_args = {
                    --                     vim.fn.stdpath("data") .. "/lazy/Trans.nvim/ultimate.db",
                    --                     "select translation from stardict where word = '" .. item .. "';",
                    --                 },
                    --                 ---@diagnostic disable-next-line: redefined-local
                    --                 resolve_documentation = function(output)
                    --                     return output
                    --                 end,
                    --             }
                    --         end,
                    --     },
                    -- },
                    env = {
                        name = "Env",
                        module = "blink-cmp-env",
                        opts = {},
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
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        keys = function()
            local ls = require("luasnip")

            return {
                {
                    "<Tab>",
                    function()
                        if ls.expand_or_jumpable() then
                            ls.jump(1)
                        else
                            return "<Tab>"
                        end
                    end,
                    mode = { "i", "s" },
                    expr = true,
                },
                {
                    "<S-Tab>",
                    function()
                        ls.jump(-1)
                    end,
                    mode = { "i", "s" },
                },
                {
                    "<C-l>",
                    function()
                        if ls.choice_active() then
                            ls.change_choice(1)
                        end
                    end,
                    mode = { "i", "s" },
                },
                {
                    "<C-h>",
                    function()
                        if ls.choice_active() then
                            ls.change_choice(-1)
                        end
                    end,
                    mode = { "i", "s" },
                },
            }
        end,
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/snippets" },
            })

            local luasnip = require("luasnip")
            luasnip.add_snippets("all", require("plugins.snippets.all"))
            luasnip.add_snippets("rust", require("plugins.snippets.rust"))
            luasnip.add_snippets("typescriptreact", require("plugins.snippets.tsx"))
        end,
    },
}
