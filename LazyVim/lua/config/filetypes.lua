vim.filetype.add({
    extension = {
        slint = "slint",
        typ = "typst",
        nu = "nu",
        d2 = "d2",
    },
    pattern = {
        [".*"] = {
            priority = -math.huge,
            function(_, bufnr)
                local shebang = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
                if vim.regex([[^#!.*\<nu\>]]):match_str(shebang) then
                    return "nu"
                end
            end,
        },
    },
})
