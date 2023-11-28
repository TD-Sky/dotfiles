local utils = require("utils")

return {
    {
        "johmsalas/text-case.nvim",
        config = function()
            local textcase = require("textcase")
            local wk = require("which-key")

            local function convert_current_word(dest_case)
                return function()
                    textcase.current_word(dest_case)
                end
            end

            wk.register({
                t = {
                    name = "text-case",
                    u = { convert_current_word("to_upper_case"), "TO UPPER" },
                    l = { convert_current_word("to_lower_case"), "to lower" },
                    s = { convert_current_word("to_snake_case"), "to_snake" },
                    ["-"] = { convert_current_word("to_dash_case"), "to-dash" },
                    C = { convert_current_word("to_constant_case"), "TO_CONSTANT" },
                    d = { convert_current_word("to_dot_case"), "to.dot" },
                    p = { convert_current_word("to_phrase_case"), "To phrase" },
                    c = { convert_current_word("to_camel_case"), "toCamel" },
                    P = { convert_current_word("to_pascal_case"), "ToPascal" },
                    t = { convert_current_word("to_title_case"), "To Title" },
                    ["/"] = { convert_current_word("to_path_case"), "to/path" },
                },
            }, { prefix = "g", mode = { "n", "x", "o" } })
        end,
    },
    {
        "machakann/vim-sandwich",
        config = function()
            vim.api.nvim_exec2(
                [[
                    let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
                    let g:sandwich#recipes += [
                    \  {
                    \    'buns': ['“', '”'],
                    \    'nesting': 1, 'match_syntax': 1,
                    \    'kind': ['add', 'delete', 'replace'],
                    \    'action': ['add', 'delete','replace'],
                    \    'input': ['“', '”']
                    \  },
                    \  {
                    \    'buns': ['（', '）'],
                    \    'nesting': 1, 'match_syntax': 1,
                    \    'kind': ['add', 'delete', 'replace'],
                    \    'action': ['add', 'delete','replace'],
                    \    'input': ['（', '）']
                    \  },
                    \ ]
                ]],
                {}
            )
        end,
    },
    {
        "utilyre/sentiment.nvim",
        version = "*",
        event = "VeryLazy",
        init = function()
            -- NOTE: Disables the built-in matchparen.vim plugin.
            -- `matchparen.vim` needs to be disabled manually in case of lazy loading
            vim.g.loaded_matchparen = 1
        end,
        config = true,
    },
    {
        "folke/flash.nvim",
        vscode = true,
        opts = {
            modes = {
                search = {
                    enabled = false,
                },
                char = {
                    enabled = false,
                },
            },
        },
        keys = function()
            local flash = require("flash")
            return {
                {
                    "U",
                    mode = { "n", "x", "o" },
                    function()
                        flash.jump()
                    end,
                    desc = "Flash Jump",
                },
                {
                    "<leader><space>",
                    mode = { "n", "x", "o" },
                    function()
                        utils.treesitter.try_exec(flash.treesitter)
                    end,
                    desc = "Flash Treesitter",
                },
            }
        end,
    },
}
