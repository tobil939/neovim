return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      direction = "horizontal",  -- Open at bottom
      size = 7,  -- Only 5 lines high
      --open_mapping = [[<C-/>]],  -- Toggle with <leader>tb
      persist_size = true,  -- Keep the same height
      shade_terminals = true,  -- Dim background slightly
    })
  end,
}


