vim.api.nvim_create_user_command("ProjectRoot", function()
    local hist_file = vim.fn.stdpath("data") .. "/neovim-project/history"
    local hist = io.open(hist_file, "a")
    if hist then
        -- 要用~替代家目录来欺骗neovim-project
        local proj = vim.fn.getcwd():gsub(vim.env.HOME, "~")
        hist:write("\n" .. proj)
        hist:flush()
        hist:close()
    end
end, { desc = "记住此项目位置" })
