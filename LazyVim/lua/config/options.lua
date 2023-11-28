-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local options = {
    -- basic
    cindent = true,
    wrap = false,
    showmatch = true,
    matchtime = 2,
    display = "lastline",
    listchars = "tab:| ,extends:>,precedes:<,nbsp:.,trail:_",
    ffs = "unix,dos,mac",

    -- tab size
    shiftwidth = 4,
    tabstop = 4,
    expandtab = true,
    shiftround = true,

    -- search
    ignorecase = true,
    smartcase = true,

    -- encoding
    encoding = "utf-8",
    fileencoding = "utf-8",

    -- ignored while searching or completing
    -- stylua: ignore
    suffixes = table.concat({
        ".bak", "~", ".o", ".h", ".info", ".swp", ".obj", ".pyc",
        ".pyo", ".egg-info", ".class",
    }, ','),
    -- stylua: ignore
    wildignore = table.concat({
        "*.o", "*.obj", "*~", "*.exe", "*.a", "*.pdb", "*.lib", "*.so",
        "*.dll", "*.swp", "*.egg", "*.jar", "*.class", "*.pyc", "*.pyo",
        "*.bin", "*.dex", "*.zip", "*.7z", "*.rar", "*.gz", "*.tar",
        "*.gzip", "*.bz2", "*.tgz", "*.xz", "*DS_Store*", "*.ipch",
        "*.gem", "*.png", "*.jpg", "*.gif", "*.bmp", "*.tga", "*.pcx",
        "*.ppm", "*.img", "*.iso", "*.so", "*.swp", "*.zip", "*/.Trash/**",
        "*.pdf", "*.dmg", "*/.rbenv/**", "*/.nx/**", "*.app", "*.git",
        ".git", "*.wav", "*.mp3", "*.ogg", "*.pcm", "*.mht", "*.suo",
        "*.sdf", "*.jnlp", "*.chm", "*.epub", "*.pdf", "*.mobi", "*.ttf",
        "*.mp4", "*.avi", "*.flv", "*.mov", "*.mkv", "*.swf", "*.swc",
        "*.ppt", "*.pptx", "*.docx", "*.xlt", "*.xls", "*.xlsx", "*.odt",
        "*.wps", "*.msi", "*.crx", "*.deb", "*.vfd", "*.apk", "*.ipa",
        "*.bin", "*.msu", "*.gba", "*.sfc", "*.078", "*.nds", "*.smd",
        "*.smc", "*.linux2", "*.win32", "*.darwin", "*.freebsd", "*.linux",
        "*.android",
    }, ','),

    -- display
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    laststatus = 3,
    list = true,
    splitright = true,
    splitbelow = true,
    cursorline = true,
    report = 0,
    scrolloff = 5,

    -- platform
    clipboard = "unnamedplus",
}

vim.opt.errorformat:append("[%f:%l] -> %m,[%f:%l]:%m")
vim.opt.formatoptions:append("mB")
vim.opt.shortmess:append('s')

local cache_dir = vim.fn.stdpath("cache")
local fs_options = {
    -- backup
    backup = true,
    writebackup = true,
    backupext = ".bak",
    backupdir = cache_dir .. "/backup/",

    -- viminfo,
    backupskip = "",
    updatecount = 100,
    viminfo = "'100,n" .. cache_dir .. "/info/viminfo",

    -- undo,
    undofile = true,
    undodir = cache_dir .. "/undo/",

    -- swap,
    directory = cache_dir .. "/swap//",
}

require("utils").table.force_extend(vim.opt, options, fs_options)
