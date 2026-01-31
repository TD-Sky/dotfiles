return {
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        opts = {
            codelens = {
                enabled = true,
            },
            -- LSP Server Settings
            servers = {
                "lua_ls",
                "texlab",
                "tombi",
                "gopls",
                "ts_ls",
                "volar",
                "tinymist",
                "bashls",
                "jsonls",
                "slint_lsp",
                "nushell",
                "clangd",
                "basedpyright",
                "astro",
            },
            capabilities = {
                workspace = {
                    fileOperations = {
                        didRename = true,
                        willRename = true,
                    },
                },
            },
        },
        config = vim.schedule_wrap(function(_, opts)
            -- 指定诊断日志的图标
            for severity, icon in pairs(opts.diagnostics.signs.text) do
                local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end

            -- inlay hints
            if opts.inlay_hints.enabled then
                Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
                    if
                        vim.api.nvim_buf_is_valid(buffer)
                        and vim.bo[buffer].buftype == ""
                        and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
                    then
                        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
                    end
                end)
            end

            -- folds
            if opts.folds.enabled then
                Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
                    if LazyVim.set_default("foldmethod", "expr") then
                        LazyVim.set_default("foldexpr", "v:lua.vim.lsp.foldexpr()")
                    end
                end)
            end

            -- code lens
            if opts.codelens.enabled and vim.lsp.codelens then
                Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
                    vim.lsp.codelens.refresh()
                    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = buffer,
                        callback = vim.lsp.codelens.refresh,
                    })
                end)
            end

            -- diagnostics
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            local default_lsp_config = {
                capabilities = vim.tbl_deep_extend(
                    "force",
                    vim.lsp.protocol.make_client_capabilities(),
                    require("blink.cmp").get_lsp_capabilities(), -- 令 blink.cmp 连接服务器
                    opts.capabilities or {}
                ),
            }
            vim.lsp.config("*", default_lsp_config)

            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--clang-tidy",
                },
            })

            vim.lsp.enable(opts.servers)
        end),
    },
    {
        "nvimdev/lspsaga.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            { "nvim-treesitter/nvim-treesitter" },
        },
        event = "LspAttach",
        keys = {
            -- 审视
            { "<S-k>", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover" },
            { "<leader>lI", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
            -- 更改
            { "<leader>lr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
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
