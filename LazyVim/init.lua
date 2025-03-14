require("config.filetypes")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.neovide then
    require("config.neovide")
end

vim.cmd.highlight("CursorWord guifg=#FF6868")
