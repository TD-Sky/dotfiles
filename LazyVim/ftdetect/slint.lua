vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.slint",
    callback = function()
        vim.opt.filetype = "slint"
    end,
})
