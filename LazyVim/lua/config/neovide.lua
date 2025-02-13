if vim.g.neovide then
    vim.g.neovide_input_ime = true
    vim.g.neovide_scale_factor = 1.0
    vim.g.neovide_cursor_animation_length = 0.13
    vim.g.neovide_cursor_trail_size = 0.3
    vim.g.neovide_scroll_animation_length = 0.3
    vim.g.neovide_scroll_animation_far_lines = 1
    vim.g.terminal_color_4 = "#268bd2"
    vim.opt.linespace = -2
    vim.g.neovide_window_blurred = false
    vim.g.neovide_floating_shadow = false
    vim.g.neovide_floating_corner_radius = 0.0
    vim.g.neovide_transparency = 1
    vim.g.neovide_normal_opacity = 1
    vim.g.neovide_underline_stroke_scale = 1.3
    vim.g.neovide_refresh_rate = 120
    vim.g.neovide_fullscreen = false
    vim.g.neovide_no_idle = true

    vim.g.neovide_cursor_vfx_modes = { "pixiedust", "ripple" }
    vim.g.neovide_cursor_vfx_opacity = 200
    vim.g.neovide_cursor_vfx_particle_lifetime = 3
    vim.g.neovide_cursor_vfx_particle_density = 10
    vim.g.neovide_cursor_vfx_particle_phase = 1.5
    vim.g.neovide_cursor_vfx_particle_curl = 0.1

    vim.g.neovide_profiler = false
end
