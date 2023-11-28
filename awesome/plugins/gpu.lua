local spawn = require("awful.spawn")
local wibox = require("wibox")

local function gpu()
    local widget = wibox.widget({
        widget = wibox.widget.textbox,
    })

    spawn.easy_async("optimus-manager --print-mode", function(stdout)
        local mode = stdout:match(": (%a+)")
        if mode == "integrated" then
            widget:set_text("💔")
        elseif mode == "nvidia" then
            widget:set_text("🖕")
        end
    end)

    return widget
end

return gpu
