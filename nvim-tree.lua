return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: für Datei-Icons
  config = function()
    require("nvim-tree").setup({
      view = { side = "left", width = 30 },
    })
      end,
}
