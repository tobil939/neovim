-- In ~/nvim/lua/plugins/luasnip.lua
return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local c = ls.choice_node
      local fmt = require("luasnip.extras.fmt").fmt

      ls.add_snippets("tex", {
        s({ trig = "\\begin", snippetType = "autosnippet" }, -- Automatisch auslösen
          fmt([[
            \begin{{{}}}
              {}
            \end{{{}}}
          ]], {
            i(1, "environment"), -- Platzhalter für Umgebung
            i(2),                -- Platzhalter für Inhalt
            i(1),                -- Wiederverwendung des ersten Werts
          })
        ),
      })

      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
