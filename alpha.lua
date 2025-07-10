-- ~/nvim/lua/plugins/alpha.lua
return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "   ██████╗ ██╗   ██╗███╗   ██╗ ██████╗  █████╗  ",
        "   ██╔══██╗██║   ██║████╗  ██║██╔════╝ ██╔══██╗ ",
        "   ██████╔╝██║   ██║██╔██╗ ██║██║  ███╗███████║ ",
        "   ██╔══██╗██║   ██║██║╚██╗██║██║   ██║██╔══██║ ",
        "   ██████╔╝╚██████╔╝██║ ╚████║╚██████╔╝██║  ██║ ",
        "   ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ",
        "      ██╗  ██╗ █████╗ ██████╗ ████████╗    ██╗  ",
        "      ██║  ██║██╔══██╗██╔══██╗╚══██╔══╝    ██║  ",
        "      ███████║███████║██████╔╝   ██║       ██║  ",
        "      ██╔══██║██╔══██║██╔══██╗   ██║       ╚═╝  ",
        "      ██║  ██║██║  ██║██║  ██║   ██║       ██╗  ",
        "      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       ╚═╝  ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("e", "📝 New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "🔍 Find file", ":Telescope find_files <CR>"),
        dashboard.button("r", "🕒 Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("q", "🚪 Quit", ":qa <CR>"),
        dashboard.button("v", "🎯 VimBeGood", ":VimBeGood <CR>"),
        dashboard.button("l", "🔧 LazyVim", ":Lazy <CR>"),
      }
      dashboard.section.footer.val = "Willkommen zu deinem Neovim!"
      alpha.setup(dashboard.config)
    end,
  },
}
