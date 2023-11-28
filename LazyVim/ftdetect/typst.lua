vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.typ",
    callback = function()
        vim.opt.filetype = "typst"
    end,
})
