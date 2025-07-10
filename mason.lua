-- ~/.config/nvim/lua/plugins/mason.lua
return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ensure_installed = {
          -- LSPs
          "lua-language-server",
          "pyright",
          "clangd",
          "bashls",
          "texlab",
          -- Formatter
          "black",
          "clang-format",
          "shfmt",
          "latexindent",
          "stylua",
          -- DAPs
          "debugpy",
          -- Linter
          "shellcheck",
          "pylint",
          "cppcheck",
          "chktex",
        },
        ui = {
          border = "single",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "clangd",
          "bashls",
          "texlab",
        },
        automatic_installation = true,
      })
    end,
  },
}
