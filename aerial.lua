return {
  -- Installiere aerial.nvim
  'stevearc/aerial.nvim',

  config = function()
    -- Setup für aerial.nvim
    require('aerial').setup({
      -- Definiere die Backend-Quellen, die aerial verwenden soll
      backends = { 'treesitter', 'lsp' }, -- Zuerst Treesitter, dann LSP als Fallback
      -- Wenn du eine spezielle Symbolart ausblenden willst, kannst du dies hier konfigurieren
      filter_kind = false,                -- Setze `true`, um Symbolarten zu filtern (z.B. nur Sections anzeigen)

      -- Aktivierung von Visual Guides für Symbole in der Sidebar
      show_guides = true, -- Zeigt Verbindungslinien zwischen den Symbolen

      -- Minimale Breite der Sidebar
      min_width = 20, -- Du kannst diese Zahl anpassen, um den Abstand der Sidebar zu verändern

      -- Weitere Anpassungen der Anzeige, falls nötig
      icon = '📄', -- Symbol für aerial (wählbar)
      layout = {
        default_direction = "right", -- Öffnet Aerial auf der linken Seite
        width = 50,                -- Optional: Breite des Fensters
      },
    })
  end,

  -- Wenn du LSP verwendest, stelle sicher, dass aerial dafür auch korrekt funktioniert.
  -- Falls du eine spezielle LSP-Integration benötigst, kannst du die LSP-Server hier hinzufügen.
  dependencies = {
    -- Falls du Tree-sitter für LaTeX verwendest
    'nvim-treesitter/nvim-treesitter',
  },

  -- Wenn du spezifische LSPs verwendest, kannst du sie hier angeben, z.B.:
  -- {
  --   'neovim/nvim-lspconfig',
  --   config = function()
  --     require'lspconfig'.texlab.setup{}
  --   end
  -- }
}
