local function trim_end()
    local current_mode = vim.fn.mode()
    local range

    if current_mode == "v" or current_mode == "V" then
        local vpos = vim.fn.getpos("v")
        local pos = vim.fn.getpos(".")
        range = string.format("%d,%d", vpos[2], pos[2])
        vim.cmd([[normal! \<Esc>]])
    else
        range = "%"
    end

    vim.ui.input({ prompt = "Pattern to delete: " }, function(pattern)
        if not pattern or pattern == "" then
            print("Canceled.")
            return
        end

        local escaped = vim.fn.escape(pattern, [[/\]])
        local cmd = string.format("%ss/%s$//g", range, escaped)

        local ok, err = pcall(vim.cmd, cmd)
        if not ok then
            print("Error: " .. err)
        else
            if range == "%" then
                print(string.format("Deleted pattern '%s' from entire file", pattern))
            else
                print(string.format("Deleted pattern '%s' from lines %s", pattern, range))
            end
        end
    end)
end

vim.keymap.set("n", "g$", trim_end, { desc = "Delete end-of-line pattern" })
vim.keymap.set("v", "g$", trim_end, { desc = "Delete end-of-line pattern (visual)" })
