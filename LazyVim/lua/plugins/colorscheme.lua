return {
    {
        "sainnhe/gruvbox-material",
        config = function()
            vim.g.gruvbox_material_backgroud = "soft"
            vim.g.gruvbox_material_current_word = "underline"
            vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
            vim.g.gruvbox_material_visual = "red background"
            vim.cmd.colorscheme("gruvbox-material")
        end,
    },
}
