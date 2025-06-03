local LazyVim = require("lazyvim.util")
local utils = require("utils")

return {
    {
        "akinsho/bufferline.nvim",
        keys = {
            { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump" },
            { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all at right" },
            { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all at left" },
        },
        opts = {
            options = {
                always_show_bufferline = true,
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        opts = {
            pickers = {
                find_files = {
                    previewer = false,
                },
                git_files = {
                    previewer = false,
                },
                live_grep = {
                    layout_config = {
                        preview_width = 0.5,
                    },
                },
            },
        },
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
        },
        config = function()
            vim.g.undotree_WindowLayout = 4
        end,
    },
    {
        "crusj/bookmarks.nvim",
        keys = {
            { "<leader>B", remap = true, desc = "Bookmarks" },
            { "<leader>m", remap = true, desc = "Make bookmark" },
            { "<leader>sB", "<cmd>Telescope bookmarks<CR>", desc = "Bookmarks" },
        },
        branch = "main",
        dependencies = { "nvim-web-devicons" },
        opts = {
            keymap = {
                toggle = "<leader>B",
                add = "<leader>m",
            },
        },
        config = function(_, opts)
            require("bookmarks").setup(opts)
            require("telescope").load_extension("bookmarks")
        end,
    },
    {
        "mikavilpas/yazi.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        keys = {
            {
                "<leader>e",
                function()
                    require("yazi").yazi()
                end,
                desc = "Open the file manager",
            },
        },
        opts = {
            open_for_directories = true,
            hooks = {
                yazi_opened_multiple_files = function(chosen_files, _, _)
                    for _, file in ipairs(chosen_files) do
                        vim.cmd("edit " .. file)
                    end
                end,
            },
        },
    },
    {
        "coffebar/neovim-project",
        opts = {
            projects = {},
            last_session_on_startup = false,
        },
        init = function()
            -- enable saving the state of plugins in the session
            vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
        end,
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
            { "Shatur/neovim-session-manager" },
        },
    },
    {
        "MagicDuck/grug-far.nvim",
        keys = {
            {
                "gs",
                function()
                    local grug = require("grug-far")

                    grug.open({
                        engine = "astgrep",
                        transient = true,
                        prefills = {
                            filesFilter = utils.path.filename(utils.vim.current_buffer_path()),
                        },
                        visualSelectionUsage = "operate-within-range",
                    })
                end,
                mode = { "n", "v" },
                desc = "Search and Replace AST in current file",
            },
            {
                "<leader>sA",
                function()
                    local grug = require("grug-far")

                    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                    grug.open({
                        engine = "astgrep",
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        },
                    })
                end,
                mode = { "n", "v" },
                desc = "Search and Replace AST",
            },
        },
    },
}
