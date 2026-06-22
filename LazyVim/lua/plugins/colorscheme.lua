return {
    {
        "sainnhe/gruvbox-material",
        -- enabled = false,
        config = function()
            vim.g.gruvbox_material_background = "soft"
            vim.g.gruvbox_material_current_word = "underline"
            vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
            vim.g.gruvbox_material_visual = "red background"
            vim.g.gruvbox_material_transparent_background = 1
            vim.cmd.colorscheme("gruvbox-material")
            -- Colors are applied automatically based on user-defined highlight groups.
            -- There is no default value.
            vim.cmd.highlight("IndentLine guifg=#808080")
            -- Current indent line highlight
            vim.cmd.highlight("IndentLineCurrent guifg=#FF6347")
        end,
    },
}
