return {
    {
        "folke/sidekick.nvim",
        opts = {
            cli = {
                tools = {
                    pi = {
                        cmd = { "nono", "run", "--profile", "work", "--", "pi" },
                    },
                },
            },
        },
    },
}
