local wezterm = require("wezterm")

return {
    max_fps = 165,
    enable_scroll_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    tab_bar_at_bottom = true,
    font = wezterm.font_with_fallback({
        "JetBrains Mono", -- 代码 <内置>
        "FiraCode Nerd Font", -- 炫酷图标
        "Noto Sans CJK SC", -- 汉字
        "DejaVu Sans Mono",
        "Noto Sans Symbols2",
        "Noto Serif Grantha", -- 古印度文
        "Noto Sans Gujarati UI", -- 古吉拉特文
    }),
    font_size = 16.5,
    color_scheme = "Gruvbox Material (Gogh)",
    force_reverse_video_cursor = true, -- 光标反色
    window_background_opacity = 0.8,
    line_height = 1.1,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    exit_behavior = "Close",
    keys = {
        {
            key = "{",
            mods = "SHIFT|ALT",
            action = wezterm.action.MoveTabRelative(-1),
        },
        {
            key = "}",
            mods = "SHIFT|ALT",
            action = wezterm.action.MoveTabRelative(1),
        },
    },
}
