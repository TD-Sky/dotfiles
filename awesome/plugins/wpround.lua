local Gtable = require("gears.table")
local Wallpaper = require("gears.wallpaper")
local Timer = require("gears.timer")
local Button = require("awful.button")

local wpround = {}

local function new_images(gallery)
    local images = {}
    local index = 0 -- make 0-base array

    -- get all images path
    gallery = gallery:gsub("^~", os.getenv("HOME"))
    local fp = io.popen("ls -1 " .. gallery)

    for img in fp:lines() do
        images[index] = gallery .. img
        index = index + 1
    end

    fp:close()

    -- shuffle
    math.randomseed(os.time())
    for i = #images, 0, -1 do
        local j = math.random(0, i)
        images[i], images[j] = images[j], images[i]
    end

    return images
end

local function next_wallpaper()
    local idx = wpround.nth

    for s in screen do
        Wallpaper.maximized(wpround.images[idx], s, false)
    end

    wpround.nth = (wpround.nth + 1) % wpround.modulus
end

local function prev_wallpaper()
    wpround.nth = (wpround.nth - 1) % wpround.modulus

    for s in screen do
        Wallpaper.maximized(wpround.images[wpround.nth], s, false)
    end
end

local function set_click_listener()
    root.buttons(Gtable.join(
        root.buttons(),
        Button({}, 1, function()
            wpround.timer:stop()
            next_wallpaper()
            wpround.timer:again()
        end),

        Button({}, 2, function()
            wpround.timer:stop()
            prev_wallpaper()
            wpround.timer:again()
        end)
    ))
end

local function worker(args)
    args = args or {}

    local gallery = args.gallery or "~/Pictures/wallpaper/" -- 末尾必须带斜杠
    local period = args.period or 300
    local browsable = args.browsable or true

    wpround.images = new_images(gallery)
    wpround.nth = 0
    wpround.modulus = #wpround.images + 1

    wpround.timer = Timer({
        timeout = period,
        autostart = true,
        call_now = true,
        callback = next_wallpaper,
    })

    if browsable then
        set_click_listener()
    end
end

return setmetatable(wpround, {
    __call = function(_, ...)
        return worker(...)
    end,
})
