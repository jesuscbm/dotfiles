local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

ls.filetype_extend("markdown", { "md", "pandoc", "markdown.pandoc" })
ls.add_snippets("markdown", {
    s("simple", t("This is a simple snippet")),
    s("header", fmt([[
---
title: {}
author: {}
lang: es-ES
geometry: margin=2cm
mainfont: sans-serif
header-includes: |
  \usepackage{{indentfirst}}
  \setlength{{\parindent}}{{2em}}
  \renewcommand{{\familydefault}}{{\sfdefault}}
  \usepackage{{float}}
  \let\origfigure\figure
  \let\endorigfigure\endfigure
  \renewenvironment{{figure}}[1][2] {{
      \expandafter\origfigure\expandafter[H]
  }} {{
      \endorigfigure
  }}
---
]],
        { i(1, "Title"), i(2, "Author") })),
})
