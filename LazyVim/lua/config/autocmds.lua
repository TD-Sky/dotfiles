-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

--# .nvim.lua
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

--# 关闭语法检查
vim.api.nvim_create_autocmd("FileType", {
    command = "setlocal nospell",
    desc = "关闭破烂语法检查",
})

--# 选择性自动调节窗口

local ignore_filetypes = { "DiffviewFiles", "DiffviewFileHistory" }
local ignore_buftypes = { "nofile", "prompt", "popup" }

local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

vim.api.nvim_create_autocmd("WinEnter", {
    group = augroup,
    callback = function(_)
        vim.w.focus_disable = vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
    end,
    desc = "Disable focus autoresize for BufType",
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    callback = function(_)
        vim.b.focus_disable = vim.tbl_contains(ignore_filetypes, vim.bo.filetype)
    end,
    desc = "Disable focus autoresize for FileType",
})
