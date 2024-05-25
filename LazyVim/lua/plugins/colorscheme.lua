return {
    {
        "sainnhe/gruvbox-material",
        config = function()
            vim.g.gruvbox_material_backgroud = "soft"
            vim.g.gruvbox_material_current_word = "underline"
            vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
            vim.g.gruvbox_material_visual = "red background"
            vim.cmd.colorscheme("gruvbox-material")
            -- Colors are applied automatically based on user-defined highlight groups.
            -- There is no default value.
            vim.cmd.highlight("IndentLine guifg=#808080")
            -- Current indent line highlight
            vim.cmd.highlight("IndentLineCurrent guifg=#FF6347")
        end,
    },
}
