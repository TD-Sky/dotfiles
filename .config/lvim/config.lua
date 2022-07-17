-- 表扩充，浅拷贝，键冲突时采用other
local function tbl_force_extend(self, other)
    for k, v in pairs(other) do
        self[k] = v
    end
end

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "gruvbox"

--------------------------------------------------------------
-- keymappings [view all the defaults by pressing <leader>Lk]
--------------------------------------------------------------

lvim.leader = "space"

lvim.keys.normal_mode = {
    ["<S-l>"] = false,
    ["<S-h>"] = false,
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["w"] = { "<cmd>set wrap!<CR>", "Wrap Toggle" }
lvim.builtin.which_key.mappings["t"] = {
    name = "+tools",
    n = { "<cmd>tabnew<CR>", "New tab" },
}
lvim.builtin.which_key.mappings["q"] = { "<cmd>HopChar1<CR>", "HopChar1" }

tbl_force_extend(lvim.builtin.which_key.mappings["b"], {
    x = { "<cmd>BufferKill<CR>", "Close current" },
    b = { "<cmd>BufferLineCyclePrev<CR>", "Goto left buffer" },
    n = { "<cmd>BufferLineCycleNext<CR>", "Goto right buffer" },
})

------------------------------------------------------------------
-- Builtin Plugins
------------------------------------------------------------------

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
tbl_force_extend(lvim.builtin.terminal, {
    active = true,
    shell = "zsh",
    direction = "horizontal",
    size = 11,
    open_mapping = [[<c-w>]],
})
lvim.builtin.lualine.style = "lvim"

------------------------------------------------------------------
-- Language
------------------------------------------------------------------

-- Treesitter
lvim.builtin.treesitter.ensure_installed = {
    "rust", "go",
    "python", "bash", "perl", "lua",
    "c", "cpp", "cmake",
    "html", "vue",
    "css", "scss",
    "javascript", "typescript",
    "java", "kotlin",
    "toml", "yaml", "json", "json5",
    "latex", "bibtex",
    "markdown", "dot",
    "vim", "comment",
}

lvim.builtin.treesitter.highlight.enabled = true

-- LSP
--[[
Needed:
  - texlab
  - bashls
  - clangd
  - gopls
  - html
  - jsonls
  - rust_analyzer
  - sumneko_lua
  - tsserver
  - volar

Deprecated:
  - tailwindcss
]]

lvim.lsp.automatic_servers_installation = false
lvim.lsp.float.focusable = true

-- Formatters
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
    { command = "rustfmt", filetypes = { "rust" } },
    { command = "shfmt", filetypes = { "sh" } },
    { command = "stylua", extra_args = { "--indent-type", "Spaces" }, filetypes = { "lua" } },
    { command = "gofmt", filetypes = { "go" }, },
    {
        command = "prettierd",
        filetypes = { "vue", "html", "json" },
    },
    {
        command = "prettierd",
        extra_args = { "--tab-width", "4" },
        filetypes = { "javascript", "typescript", "css", "scss", "yaml" },
    },
    --[[
    {
        command = "clang-format",
        extra_args = {
            "-style", "{IndentWidth: 4, BreakBeforeBraces: Allman}",
        },
        filetypes = { "c", "cpp" },
    },
    ]]
})

-- Additional Plugins
lvim.plugins = {
    {
        "npxbr/gruvbox.nvim",
        requires = { "rktjmp/lush.nvim" },
    },
    {
        "phaazon/hop.nvim",
        event = "BufRead",
        config = function()
            require("hop").setup()
        end,
    },
    {
        "machakann/vim-sandwich",
        event = "BufReadPost",
        config = function()
            vim.api.nvim_exec(
                [[
                    let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
                    let g:sandwich#recipes += [
                        \ {'buns': ['“', '”'], 'nesting': 1, 'match_syntax': 1,
                        \  'kind': ['add', 'delete', 'replace'], 'action': ['add', 'delete','replace'], 'input': ['“', '”'] },
                        \ {'buns': ['（', '）'], 'nesting': 1, 'match_syntax': 1,
                        \  'kind': ['add', 'delete', 'replace'], 'action': ['add', 'delete','replace'], 'input': ['（', '）'] },
                        \ ]
                ]],
                false
            )
        end,
    },
    {
        "simrat39/symbols-outline.nvim",
        config = function()
            lvim.builtin.which_key.mappings["tf"] = { "<cmd>SymbolsOutline<cr>", "SymbolsOutline" }
        end,
    },
    {
        "mbbill/undotree",
        config = function()
            vim.g.undotree_WindowLayout = 4
            lvim.builtin.which_key.mappings["tu"] = { "<cmd>UndotreeToggle<cr>", "Undotree" }
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        ft = "markdown",
        config = function()
            vim.g.mkdp_auto_start = 1
            lvim.builtin.which_key.mappings["tm"] = { "<cmd>MarkdownPreviewToggle<CR>", "markdown-preview" }
        end,
    },
    {
        "lervag/vimtex",
        ft = "tex",
        config = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_view_general_viewer = "zathura"
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_latexmk = { continuous = 0, callback = 0 }
        end,
    },
}

vim.api.nvim_create_autocmd("BufReadPost",
    {
        command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]],
    }
)

-----------------------------------------------------------
-- tab size
-----------------------------------------------------------

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.textwidth = 0
vim.opt.indentexpr = ""

-----------------------------------------------------------
-- tiny
-----------------------------------------------------------

-- basic
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 50
vim.opt.ruler = true
vim.opt.wrap = false

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- others
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.display = "lastline"
vim.opt.wildmenu = true
vim.opt.lazyredraw = true
vim.opt.errorformat:append("[%f:%l] -> %m,[%f:%l]:%m")
vim.opt.listchars = "tab:| ,extends:>,precedes:<,nbsp:.,trail:_"
vim.opt.tags = "./.tags;,.tags"
vim.opt.formatoptions:append("mB")
vim.opt.ffs = "unix,dos,mac"

-- 文件搜索和补全时忽略以下扩展名
vim.opt.suffixes = ".bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class"
vim.opt.wildignore = "*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib,*.so,*.dll,*.swp,\z
                      *.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex,*.zip,*.7z,\z
                      *.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz,*DS_Store*,\z
                      *.ipch,*.gem,*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,\z
                      *.img,*.iso,*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,\z
                      */.rbenv/**,*/.nx/**,*.app,*.git,.git,*.wav,*.mp3,*.ogg,\z
                      *.pcm,*.mht,*.suo,*.sdf,*.jnlp,*.chm,*.epub,*.pdf,*.mobi,\z
                      *.ttf,*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc,*.ppt,\z
                      *.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps,*.msi,*.crx,\z
                      *.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu,*.gba,*.sfc,*.078,\z
                      *.nds,*.smd,*.smc,*.linux2,*.win32,*.darwin,*.freebsd,\z
                      *.linux,*.android"

-----------------------------------------------------------
-- config
-----------------------------------------------------------

local cache_dir = os.getenv("HOME") .. "/.cache/vim"

-- backup
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupext = ".bak"
vim.opt.backupdir = cache_dir .. "/backup/"

-- viminfo
vim.opt.backupskip = ""
vim.opt.updatecount = 100
vim.opt.viminfo = "'100,n" .. cache_dir .. "/info/viminfo"

-- undo
vim.opt.undofile = true
vim.opt.undodir = cache_dir .. "/undo/"

-- swap
vim.opt.directory = cache_dir .. "/swap//"

-----------------------------------------------------------
-- style
-----------------------------------------------------------

-- display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.showcmd = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.sidescroll = 1
vim.opt.report = 0
vim.opt.scrolloff = 5
vim.opt.cmdheight = 1

-- color
vim.opt.background = "dark"

-- statusline
--vim.opt.statusline = [[ %F [%1*%M%*%n%R%H]%= %y %0(%{&fileformat} [%{(&fenc==""?&enc:&fenc).(&bomb?",BOM":"")}] %v:%l/%L%)]]

-- 标示空白符
if vim.fn.has("multi_bytes") then
    vim.opt.listchars = "tab:▸ ,extends:❯,precedes:❮,nbsp:±,trail:▫"
end
