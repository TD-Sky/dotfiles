local wibox = require("wibox")
local awful = require("awful")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")

local volume = {}

-- mixer
local STATUS = "pamixer --get-mute --get-volume"

local TOGGLE = STATUS .. " -t"

local function INC(step)
    return STATUS .. " -i " .. step
end

local function DEC(step)
    return STATUS .. " -d " .. step
end

-- redraw widget
local function update(stdout)
    local mute, level = stdout:match("(%a+) (%d+)")

    if mute == "true" then
        volume.widget.icon:set_text("🔇 ")
    elseif mute == "false" then
        volume.widget.icon:set_text("🔊 ")
    else
        return
    end

    volume.widget.level:set_text(level .. "%")
end

-- mixer interface
function volume:inc(step)
    spawn.easy_async(INC(step), update)
end

function volume:dec(step)
    spawn.easy_async(DEC(step), update)
end

function volume:toggle()
    spawn.easy_async(TOGGLE, update)
end

-- build widget
local function worker(args)
    args = args or {}

    local font = args.font or beautiful.font

    volume.widget = wibox.widget({
        {
            id = "icon",
            font = font,
            widget = wibox.widget.textbox,
        },
        {
            id = "level",
            font = font,
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.fixed.horizontal,
    })

    spawn.easy_async(STATUS, update)

    volume.widget:buttons(awful.util.table.join(
        awful.button({}, 4, function()
            volume:inc(1)
        end),
        awful.button({}, 5, function()
            volume:dec(1)
        end)
    ))

    return volume.widget
end

return setmetatable(volume, {
    __call = function(_, ...)
        return worker(...)
    end,
})
