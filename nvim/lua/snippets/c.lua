local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("c", {
    -- File Header Comment
    s("file", fmt([[
/**
 * @file {}
 * @brief {}
 *
 * {}
 *
 * @author {}
 * @date {}
 */
]],
        { i(1, "filename.h"), i(2, "Brief description"), i(3, "Detailed description"), i(4, "Your Name"), i(5,
            "YYYY-MM-DD") })),

    -- Function Comment
    s("func", fmt([[
/**
 * @brief {}
 *
 * {}
 *
 * @param[in] {} {}
 * @param[out] {} {}
 * @return {}
 */
]],
        { i(1, "Brief description"), i(2, "Detailed explanation"), i(3, "param1"), i(4, "Description"), i(5, "param2"), i(
        6, "Description"), i(7, "Return description") })),

    -- Struct Comment
    s("struct", fmt([[
/**
 * @struct {}
 * @brief {}
 *
 * {}
 */
]], { i(1, "StructName"), i(2, "Brief description"), i(3, "Detailed description") })),

    -- Attribute Comment
    s("attr", fmt([[
/**< {} */
]], { i(1, "Description of the attribute") })),

    -- Enum Comment
    s("enum", fmt([[
/**
 * @enum {}
 * @brief {}
 *
 * {}
 */
]], { i(1, "EnumName"), i(2, "Brief description"), i(3, "Detailed description") })),

    -- Macro Comment
    s("macro", fmt([[
/**
 * @def {}
 * @brief {}
 *
 * {}
 */
]], { i(1, "MACRO_NAME"), i(2, "Brief description"), i(3, "Detailed description") })),

    -- Typedef Comment
    s("typedef", fmt([[
/**
 * @typedef {}
 * @brief {}
 *
 * {}
 */
]], { i(1, "TypeName"), i(2, "Brief description"), i(3, "Detailed description") })),
})
