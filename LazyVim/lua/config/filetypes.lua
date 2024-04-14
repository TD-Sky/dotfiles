vim.filetype.add({
    extension = {
        slint = "slint",
        typ = "typst",
        nu = "nu",
    },
    pattern = {
        [".*"] = {
            priority = -math.huge,
            function(path, bufnr)
                local shebang = vim.filetype.getlines(bufnr, 1)
                if vim.filetype.matchregex(shebang, [[^#!.*\<nu\>]]) then
                    return "nu"
                end
            end,
        },
    },
})
