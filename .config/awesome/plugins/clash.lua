local spawn = require("awful.spawn")
local wibox = require("wibox")

local clash = {}

local TURN_ON = "clash"
local TURN_OFF = "pkill clash"

local STATUS = [[procs --no-header --only 'Command' -a 'clash']]

clash.on = function()
    spawn.easy_async(STATUS, function(stdout)
        if stdout == "" then
            clash.widget:set_text("😼")
            spawn.easy_async(TURN_ON)
        end
    end)
end

clash.off = function()
    spawn.easy_async(TURN_OFF, function(_)
        clash.widget:set_text("  ")
    end)
end

-- build widget
local function worker()
    clash.widget = wibox.widget({
        widget = wibox.widget.textbox,
    })

    spawn.easy_async(STATUS, function(stdout)
        if stdout == "" then
            clash.widget:set_text("  ")
        else
            clash.widget:set_text("😼")
        end
    end)

    return clash.widget
end

return setmetatable(clash, {
    __call = function()
        return worker()
    end,
})
