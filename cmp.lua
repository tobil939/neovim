-- ~/.config/nvim/lua/plugins/cmp.lua
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP-Quelle für Autovervollständigung
      "hrsh7th/cmp-buffer", -- Buffer-Quelle
      "hrsh7th/cmp-path", -- Dateipfad-Quelle
      "hrsh7th/cmp-cmdline", -- Kommandozeilen-Quelle
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { "i", "s" }),
}),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' }, -- LSP als Quelle
          { name = 'buffer' }, -- Buffer als Quelle
          { name = 'path' }, -- Dateipfade als Quelle
        }),
      })

      -- Autovervollständigung für Kommandozeile
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'cmdline' },
          { name = 'path' },
        },
      })

      -- Autovervollständigung für Suche (/)
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })
    end,
  },
}
