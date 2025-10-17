local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node
local f = ls.function_node
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local m = extras.m

return {
    s(
        {
            trig = "us",
            name = "React useState hook",
        },
        fmt("const [{}, set{}] = useState{}{}{}({});", {
            i(1, "state"),
            f(function(args)
                return args[1][1]:gsub("^%l", string.upper)
            end, { 1 }),
            m(2, "%S", "<"),
            c(2, {
                i(nil, "Type"),
                t(""),
            }),
            m(2, "%S", ">"),
            i(3, "initValue"),
        })
    ),
}
