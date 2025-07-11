-- ~/nvim/lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "c", "cpp", "latex", "python", "asm", "bash" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = false },
}
