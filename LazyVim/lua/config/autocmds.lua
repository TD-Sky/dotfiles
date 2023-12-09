-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(_)
        local root_dir = require("lazyvim.util").root.get()
        local cwd = vim.loop.cwd()
        local exrc = root_dir .. "/.nvim.lua"
        if root_dir ~= cwd and vim.loop.fs_stat(exrc) ~= nil then
            vim.cmd("luafile " .. exrc)
        end
    end,
})
