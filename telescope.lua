-- ~/nvim/lua/plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false, -- Telescope sofort laden
  },
  { "nvim-telescope/telescope-ui-select.nvim" },
}
