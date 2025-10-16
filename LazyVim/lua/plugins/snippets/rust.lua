local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node

return {
    s("lf", {
        t("'"),
        c(1, {
            t("a"),
            t("static"),
        }),
        t(" "),
    }),
}
