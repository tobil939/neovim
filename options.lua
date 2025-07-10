-- ~/nvim/lua/config/options.lua
vim.opt.expandtab = true      -- Tabs in Leerzeichen umwandeln
vim.opt.tabstop = 2           -- 2 Leerzeichen für einen Tab
vim.opt.softtabstop = 2       -- 2 Leerzeichen für weiche Tabs
vim.opt.shiftwidth = 2        -- 2 Leerzeichen für Einrückung
vim.opt.number = true         -- Zeilennummern anzeigen
vim.opt.relativenumber = true -- Relative Zeilennummern anzeigen
vim.opt.clipboard = "unnamedplus" -- System-Zwischenablage verwenden
--vim.opt.formatoptions:remove("o") -- Verhindert Kommentarfortsetzung bei Zeilenumbruch
--vim.opt.formatoptions:remove("r") -- Verhindert Kommentarfortsetzung bei Zeilenumbruch
vim.opt.formatoptions = vim.opt.formatoptions - "o" - "r"
vim.opt.spell = false -- Rechtschreibprüfung standardmäßig aus
vim.opt.spelllang = { "en_us", "de_de" } -- Verfügbare Sprachen
vim.opt.spellfile = vim.fn.expand("~/.local/share/nvim/site/spell/en.utf-8.add") .. "," .. vim.fn.expand("~/.local/share/nvim/site/spell/de.utf-8.add") -- Eigene Wörter für beide Sprachen
vim.opt.spellsuggest = "best,10" -- 10 Vorschläge

