return {
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            local opts_ext = {
                servers = {
                    ["*"] = {
                        keys = {
                            {
                                "<leader>lI",
                                function()
                                    Snacks.picker.lsp_config()
                                end,
                                desc = "Lsp Info",
                            },
                            { "gy", vim.lsp.buf.declaration, desc = "Goto Declaration" },
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
                            { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover" },
                            {
                                "gK",
                                vim.lsp.buf.signature_help,
                                desc = "Signature Help",
                                has = "signatureHelp",
                            },
                            {
                                "<c-k>",
                                vim.lsp.buf.signature_help,
                                mode = "i",
                                desc = "Signature Help",
                                has = "signatureHelp",
                            },
                            {
                                "<leader>la",
                                vim.lsp.buf.code_action,
                                desc = "Code Action",
                                mode = { "n", "x" },
                                has = "codeAction",
                            },
                            {
                                "<leader>lc",
                                vim.lsp.codelens.run,
                                desc = "Run Codelens",
                                mode = { "n", "x" },
                                has = "codeLens",
                            },
                            {
                                "<leader>lC",
                                vim.lsp.codelens.refresh,
                                desc = "Refresh & Display Codelens",
                                mode = { "n" },
                                has = "codeLens",
                            },
                            {
                                "<leader>lR",
                                function()
                                    Snacks.rename.rename_file()
                                end,
                                desc = "Rename File",
                                mode = { "n" },
                                has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
                            },
                            { "<leader>lr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
                            { "<leader>lA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
                            {
                                "]]",
                                function()
                                    Snacks.words.jump(vim.v.count1)
                                end,
                                has = "documentHighlight",
                                desc = "Next Reference",
                                enabled = function()
                                    return Snacks.words.is_enabled()
                                end,
                            },
                            {
                                "[[",
                                function()
                                    Snacks.words.jump(-vim.v.count1)
                                end,
                                has = "documentHighlight",
                                desc = "Prev Reference",
                                enabled = function()
                                    return Snacks.words.is_enabled()
                                end,
                            },
                            {
                                "<a-n>",
                                function()
                                    Snacks.words.jump(vim.v.count1, true)
                                end,
                                has = "documentHighlight",
                                desc = "Next Reference",
                                enabled = function()
                                    return Snacks.words.is_enabled()
                                end,
                            },
                            {
                                "<a-p>",
                                function()
                                    Snacks.words.jump(-vim.v.count1, true)
                                end,
                                has = "documentHighlight",
                                desc = "Prev Reference",
                                enabled = function()
                                    return Snacks.words.is_enabled()
                                end,
                            },
                            {
                                "<leader>co",
                                LazyVim.lsp.action["source.organizeImports"],
                                desc = "Organize Imports",
                                has = "codeAction",
                                enabled = function(buf)
                                    local code_actions = vim.tbl_filter(function(action)
                                        return action:find("^source%.organizeImports%.?$")
                                    end, LazyVim.lsp.code_actions({ bufnr = buf }))
                                    return #code_actions > 0
                                end,
                            },
                        },
                    },
                    lua_ls = { enable = true },
                    texlab = { enable = true },
                    tombi = { enable = true },
                    gopls = { enable = true },
                    vtsls = { enable = true },
                    tailwindcss = { enable = true },
                    volar = { enable = true },
                    tinymist = { enable = true },
                    bashls = { enable = true },
                    jsonls = { enable = true },
                    slint_lsp = { enable = true },
                    nushell = { enable = true },
                    clangd = { enable = true },
                    basedpyright = { enable = true },
                    astro = { enable = true },
                    phpantom_lsp = { enable = true },
                },
            }
            return vim.tbl_deep_extend("force", opts, opts_ext)
        end,
    },
    {
        "nvimdev/lspsaga.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            { "nvim-treesitter/nvim-treesitter" },
        },
        event = "LspAttach",
        keys = {
            {
                "<leader>ll",
                vim.lsp.codelens.run,
                mode = "n",
                desc = "Code Lens",
            },
            { "<leader>ls", "<cmd>Lspsaga outline<cr>", desc = "Outline" },
            { "<leader>li", "<cmd>Lspsaga incoming_calls<cr>", desc = "Incoming calls tree" },
            { "<leader>lo", "<cmd>Lspsaga outgoing_calls<cr>", desc = "Outgoing calls tree" },
        },
        opts = {
            outline = {
                win_width = 50,
                close_after_jump = true,
                keys = {
                    toggle_or_jump = "e",
                    jump = "o",
                },
            },
            ui = {
                code_action = "󰞇",
            },
            finder = {
                max_height = 0.8,
                default = "ref",
            },
        },
    },
}
