local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node

return {
    s({
        trig = "dat",
        name = "date (short)",
    }, {
        f(function(_)
            return os.date("%Y%m%d")
        end, {}),
    }),
    s({
        trig = "date",
        name = "date (long)",
    }, {
        f(function(_)
            return os.date("%Y-%m-%d")
        end, {}),
    }),
}
