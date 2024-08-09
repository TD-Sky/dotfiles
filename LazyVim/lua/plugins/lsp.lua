return {
    {
        "neovim/nvim-lspconfig",
        event = "LazyFile",
        opts = {
            diagnostics = {
                update_in_insert = true,
            },
            inlay_hints = {
                enabled = false,
            },
            codelens = {
                enabled = true,
            },
            -- LSP Server Settings
            servers = {
                lua_ls = {},
                texlab = {},
                taplo = {},
                gopls = {},
                tsserver = {},
                volar = {},
                tinymist = {},
                bashls = {},
                jsonls = {},
                slint_lsp = {
                    root_dir = require("lspconfig").util.root_pattern(),
                },
                nushell = {},
                clangd = {},
            },
        },
        config = function(_, opts)
            LazyVim.lsp.setup()

            vim.lsp.inlay_hint.enable(opts.inlay_hints.enabled)

            if opts.codelens.enabled then
                LazyVim.lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
                    vim.lsp.codelens.refresh()
                    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
                        buffer = buffer,
                        callback = vim.lsp.codelens.refresh,
                    })
                end)
            end

            if vim.g.project_lspconfig ~= nil then
                opts.servers = vim.tbl_deep_extend("force", opts.servers, vim.g.project_lspconfig)
                opts.servers.rust_analyzer = nil
            end

            -- 指定诊断日志的图标
            for level, icon in pairs(require("lazyvim.config").icons.diagnostics) do
                level = "DiagnosticSign" .. level
                vim.fn.sign_define(level, { text = icon, texthl = level, numhl = "" })
            end
            -- 配置诊断
            vim.diagnostic.config(opts.diagnostics)

            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities(), -- 令 cmp-nvim-lsp 连接服务器
                opts.capabilities or {}
            )

            for server, server_opts in pairs(opts.servers) do
                server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
                -- 如果语言服务器不支持语义化token，高亮就会fallback到treesitter
                require("lspconfig")[server].setup(server_opts)
            end
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
            -- 跳转
            { "gD", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Goto Type Definition" },
            { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
            { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
            { "gR", "<cmd>Telescope lsp_references<cr>", desc = "References" },
            { "gr", "<cmd>Lspsaga finder ref<cr>", desc = "Saga References" },
            { "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Prev Diagnostic" },
            { "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next Diagnostic" },
            {
                "[e",
                function()
                    require("lspsaga.diagnostic"):goto_prev({
                        severity = vim.diagnostic.severity.ERROR,
                    })
                end,
                desc = "Prev Error",
            },
            {
                "]e",
                function()
                    require("lspsaga.diagnostic"):goto_next({
                        severity = vim.diagnostic.severity.ERROR,
                    })
                end,
                desc = "Next Error",
            },
            -- 审视
            { "<S-k>", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover" },
            { "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Line Diagnostics" },
            { "<leader>lI", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
            -- 更改
            { "<leader>lr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
            {
                "<leader>la",
                "<cmd>Lspsaga code_action<cr>",
                desc = "Code Action",
                mode = { "n", "v" },
            },
            {
                "<leader>lA",
                function()
                    vim.lsp.buf.code_action({
                        context = { only = { "source" }, diagnostics = {} },
                    })
                end,
                desc = "Source Action",
            },
            { "<leader>ls", "<cmd>Lspsaga outline<cr>", desc = "Outline" },
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
