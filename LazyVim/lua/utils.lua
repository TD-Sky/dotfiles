local M = {
    table = {},
    vim = {},
    string = {},
    treesitter = {},
}

-- 表扩充，浅拷贝，键冲突时采用other
function M.table.force_extend(self, ...)
    local others = { ... }
    for _, other in ipairs(others) do
        for k, v in pairs(other) do
            self[k] = v
        end
    end
end

-- 获取当前缓冲区的文件名
function M.vim.current_buffer_name()
    return vim.api.nvim_buf_get_name(0)
end

-- 判断字符串末尾是否匹配指定模式
function M.string.ends_with(str, pat)
    return str:sub(-#pat) == pat
end

-- 检测缓冲区是否有treesitter解析器，是则执行所传入函数
function M.treesitter.try_exec(f)
    local ok, _ = pcall(vim.treesitter.get_parser)
    if ok then
        f()
    end
end

return M
