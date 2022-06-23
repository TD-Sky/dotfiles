local wezterm = require("wezterm")

return {
    font = wezterm.font_with_fallback({
        "JetBrains Mono",               -- 美观代码
        "FiraCode Nerd Font",           -- 图标
        "NotoSansMonoCJKsc-Regular",    -- 汉字
        "DejaVuSansMono",               -- 符号
    }),
    font_size = 16.5,
    color_scheme = "Gruvbox Dark",
    window_background_opacity = 0.7,
    text_background_opacity = 0.5,
    enable_tab_bar = false,
    line_height = 1.1,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    exit_behavior = "Close",
}
