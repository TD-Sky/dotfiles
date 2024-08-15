return {
    {
        "saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        tag = "stable",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = function()
            local crates = require("crates")
            return {
                { "<leader>ci", crates.show_crate_popup, ft = "toml", desc = "查看信息" },
                { "<leader>cv", crates.show_versions_popup, ft = "toml", desc = "挑选版本" },
                { "<leader>cf", crates.show_features_popup, ft = "toml", desc = "挑选特性" },
                { "<leader>ct", crates.extract_crate_into_table, ft = "toml", desc = "提取成表" },
            }
        end,
        opts = {
            popup = {
                autofocus = true,
                hide_on_select = true,
            },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        ft = { "rust" },
        keys = {
            { "<leader>ce", "<cmd>RustLsp expandMacro<CR>", ft = "rust", desc = "展开宏" },
            { "<leader>cg", "<cmd>RustLsp openCargo<CR>", ft = "rust", desc = "编辑Cargo.toml" },
            { "<leader>ct", "<cmd>RustLsp hover range<CR>", mode = { "v" }, ft = "rust", desc = "值类型" },
            {
                "<leader>ch",
                function()
                    vim.cmd.RustLsp({ "hover", "actions" })
                    vim.cmd.RustLsp({ "hover", "actions" })
                end,
                ft = "rust",
                desc = "代码动作",
            },
            { "gp", "<cmd>RustLsp parentModule<CR>", ft = "rust", desc = "回到父模块" },
        },
        opts = {
            tools = {
                inlay_hints = {
                    only_current_line = true,
                },
            },
            server = {
                settings = {
                    ["rust-analyzer"] = {
                        check = {
                            command = "clippy",
                            extraArgs = {
                                "--",
                                "--no-deps",
                            },
                            workspace = false,
                        },
                        checkOnSave = true,
                    },
                },
            },
        },
        config = function(_, opts)
            --  project_lspconfig 就是`plugins/lsp.lua`的 nvim-lspconfig 的`opts.servers`
            local project_lspconfig = vim.g.project_lspconfig
            if project_lspconfig ~= nil and project_lspconfig.rust_analyzer ~= nil then
                opts.server = vim.tbl_deep_extend("force", opts.server, project_lspconfig.rust_analyzer)
            end

            vim.g.rustaceanvim = opts
        end,
    },
    {
        "vxpm/ferris.nvim",
        keys = function()
            return {
                {
                    "<leader>cm",
                    require("ferris.methods.view_memory_layout"),
                    desc = "View memory layout",
                },
            }
        end,
    },
}
