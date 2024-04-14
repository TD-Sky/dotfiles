vim.api.nvim_create_user_command("LspConfig", function()
    vim.print(vim.lsp.get_active_clients()[1].config.settings)
end, { desc = "获取语言服务器的配置" })
