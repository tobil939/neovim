return {
  {
    "stevearc/conform.nvim",
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          python = { "black" },
          lua = { "stylua" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          sh = { "shfmt" },
          tex = { "latexindent" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = false,
        },
        formatters = {
          clang_format = { command = "clang-format", args = { "--style=llvm" } },
          shfmt = { command = "shfmt", args = { "-i", "2" } },
          latexindent = { command = "latexindent", args = { "-l", "-m" } },
        },
      })
    end,
  },
}

