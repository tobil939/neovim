return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "nvim-neotest/nvim-nio" },
			{ "rcarriga/nvim-dap-ui" },
			{ "theHamsta/nvim-dap-virtual-text" },
			{ "williamboman/mason.nvim" },
		},
		config = function()
			local ok, dapui = pcall(require, "dapui")
			if not ok then
				vim.notify("Error: Failed to load nvim-dap-ui", vim.log.levels.ERROR)
				return
			end
			local dap = require("dap")

			-- UI Setup
			dapui.setup({
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = { "repl" },
						size = 0.2,
						position = "bottom",
					},
				},
			})

			-- === Adapters ===
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "-i", "dap" },
			}

			dap.adapters.sh = {
				type = "executable",
				command = "bash-debug-adapter",
				args = {},
			}

			dap.adapters.python = {
				type = "executable",
				command = "python3",
				args = { "-m", "debugpy.adapter" },
			}

			dap.adapters.gdb_arm = {
				type = "executable",
				command = "arm-none-eabi-gdb",
				args = { "-q", "--interpreter=dap" },
			}

			-- === Configurations ===
			dap.configurations.c = {
				{
					name = "Launch C",
					type = "gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = vim.fn.expand("%:p:h"),
					stopAtEntry = true,
				},
				{
					name = "Launch ARM",
					type = "gdb_arm",
					request = "launch",
					program = function()
						return vim.fn.input("Path to ARM elf: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = true,
					setupCommands = {
						{ text = "target remote localhost:3333" },
						{ text = "load" },
					},
				},
			}
			dap.configurations.cpp = dap.configurations.c

			dap.configurations.sh = {
				{
					name = "Debug Bash Script",
					type = "sh",
					request = "launch",
					program = "${file}",
					cwd = "${workspaceFolder}",
					args = {}, -- Script-Argumente falls nötig
				},
			}

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch Python",
					program = "${file}",
					pythonPath = function()
						return vim.fn.exepath("python3") or "/usr/bin/python3"
					end,
					stopOnEntry = true,
				},
			}

			dap.configurations.octave = {
				{
					name = "Launch Octave",
					type = "gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to Octave binary: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					args = { "--no-gui" },
					stopAtEntry = false,
				},
			}

			require("nvim-dap-virtual-text").setup()
		end, -- <<<<<< hier hat bei dir das `end` gefehlt
	},
}
