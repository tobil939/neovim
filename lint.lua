-- ~/.config/nvim/lua/plugins/lint.lua
return {
  {
    "mfussenegger/nvim-lint",
    dependencies = { "williamboman/mason.nvim" }, -- Abhängigkeit
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        python = { "pylint" },
        c = { "cppcheck" },
        cpp = { "cppcheck" },
        tex = { "chktex" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
