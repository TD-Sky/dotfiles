-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(_)
        local root_dir = require("lazyvim.util").root.get()
        local cwd = vim.fn.getcwd()
        local exrc = root_dir .. "/.nvim.lua"
        if root_dir ~= cwd and vim.fn.filereadable(exrc) == 1 then
            vim.cmd("luafile " .. exrc)
        end
    end,
    desc = "所在目录非项目根时，读取当前目录下的`.nvim.lua`",
})

vim.api.nvim_create_autocmd("FileType", {
    command = "setlocal nospell",
    desc = "关闭破烂语法检查",
})
