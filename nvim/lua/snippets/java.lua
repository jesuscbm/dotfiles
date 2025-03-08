local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local f = ls.function_node

-- Capitalizes the first letter of a string (for method naming)
local function capitalize(args)
    return args[1][1]:sub(1,1):upper() .. args[1][1]:sub(2)
end

ls.add_snippets("java", {
    -- Getter
    s("getter", {
        t("public "), i(1, "Type"), t(" get"),
        f(capitalize, {2}), t("() {"),
        t({"", "    return "}), i(2, "variable"), t(";"),
        t({"", "}"}),
    }),

    -- Setter
    s("setter", {
        t("public void set"),
        f(capitalize, {2}), t("("), i(1, "Type"), t(" "), i(2, "variable"), t(") {"),
        t({"", "    this."}), f(function(args) return args[1][1] end, {2}), t(" = "), f(function(args) return args[1][1] end, {2}), t(";"),
        t({"", "}"}),
    }),

    -- Class Documentation
    s("jclass", {
        t({"/**", " * "}), i(1, "Class description"),
        t({"", " * "}),
        t({"", " * @author "}), i(2, "Your Name"),
        t({"", " * @version "}), i(3, "1.0"),
        t({"", " */"}),
    }),

    -- Method Documentation
    s("jmethod", {
        t({"/**", " * "}), i(1, "Method description"),
        t({"", " * "}),
        t({"", " * @param "}), i(2, "paramName"), t(" "), i(3, "Description"),
        t({"", " * @return "}), i(4, "Return description"),
        t({"", " */"}),
    }),

    -- Constructor Documentation
    s("jconstructor", {
        t({"/**", " * Constructor for "}), i(1, "ClassName"),
        t({".", " * "}),
        t({"", " * @param "}), i(2, "paramName"), t(" "), i(3, "Description"),
        t({"", " */"}),
    }),

    -- Field Documentation
    s("jfield", {
        t({"/**", " * "}), i(1, "Field description"),
        t({"", " */"}),
    }),

})
