vim.filetype.add({
    extension = {
        d2 = "d2",
        json = "jsonc",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "nu" },
    callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.expandtab = true
        vim.opt_local.softtabstop = 4
    end,
    desc = "默认的 nushell 缩进是2，官方设为4",
})
