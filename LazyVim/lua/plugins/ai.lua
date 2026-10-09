return {
    {
        "folke/sidekick.nvim",
        opts = {
            cli = {
                tools = {
                    pi = {
                        cmd = { "nono", "--profile", "work", "--", "pi" },
                    },
                },
            },
        },
    },
}
