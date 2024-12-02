require("starship"):setup()
require("session"):setup({
    sync_yanked = true,
})
require("git"):setup({
    show_branch = true
})
