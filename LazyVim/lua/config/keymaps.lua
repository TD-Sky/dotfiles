-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")
local map = {
    n = function(mapping)
        for _, m in ipairs(mapping) do
            vim.keymap.set("n", m[1], m[2], { desc = m.desc })
        end
    end,
    i = function(mapping)
        for key, op in pairs(mapping) do
            vim.keymap.set("i", key, op)
        end
    end,
    v = function(mapping)
        for key, op in pairs(mapping) do
            vim.keymap.set("v", key, op)
        end
    end,
}

-- 删除LazyVim映射的键位
vim.keymap.del("n", "<Leader>l")
vim.keymap.del("n", "<Leader>gG")
vim.keymap.del("n", "<Leader>cd")
vim.keymap.del({ "n", "i", "v" }, "<C-s>")

wk.add({ "<leader>l", group = "language" })

-- 切换标签页
map.n({
    { "[t", "<cmd>tabNext<cr>", desc = "Prev tab" },
    { "]t", "<cmd>tabnext<cr>", desc = "Next tab" },
    { "<C-s>", "<cmd>SudaWrite<cr>", desc = "sudo write" },
    -- My commands
    {
        "<leader><CR>",
        function()
            vim.system({ "open-wezterm-here" })
        end,
        desc = "Open Wezterm here",
    },
    { "<leader>lc", "<cmd>LspConfig<cr>", desc = "Lsp Config" },
})

-- emacs keymaps
map.i({
    -- move
    ["<C-b>"] = "<Left>",
    ["<C-f>"] = "<Right>",
    -- jump
    ["<C-a>"] = "<C-o>^",
    ["<C-e>"] = "<C-o>$",
    -- delete
    ["<C-d>"] = "<C-o>dl",
    ["<C-u>"] = "<ESC>^C",
})

-- line text object
map.v({
    ["ik"] = "0o$h", -- exclude end
    ["ak"] = "0o$", -- include end
})
vim.keymap.set("o", "ik", "<cmd>normal vik<cr>")
