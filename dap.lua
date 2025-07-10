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
            -- Stelle sicher, dass dapui vor der Konfiguration geladen wird
            local ok, dapui = pcall(require, "dapui")
            if not ok then
                vim.notify("Error: Failed to load nvim-dap-ui", vim.log.levels.ERROR)
                return
            end
            local dap = require("dap")

            -- DAP-UI Setup
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

            -- Adapter für verschiedene Sprachen
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "-i", "dap" },
            }

            dap.adapters.bashdb = {
                type = "executable",
                command = "bashdb",
                args = { "-q", "--" },
            }

            dap.adapters.python = {
                type = "executable",
                command = "python3",
                args = { "-m", "debugpy.adapter" },
            }

            dap.adapters.gdb_arm = {
                type = "executable",
                command = "arm-none-eabi-gdb",
                args = { "-q", "--interpreter=dap" }, -- Angepasst an die erste Datei
            }

            -- Hilfsfunktion zur Ermittlung des ausführbaren Pfads
            local function get_executable_path()
                if vim.fn.expand("%:e") ~= "c" and vim.fn.expand("%:e") ~= "cpp" then
                    vim.notify("⚠️ No C/C++ file open, please specify executable path.", vim.log.levels.WARN)
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end
                local file_dir = vim.fn.expand("%:p:h")
                local file_name = vim.fn.expand("%:t:r")
                local full_path = file_dir .. "/" .. file_name
                if vim.fn.filereadable(full_path) == 1 then
                    return full_path
                else
                    -- Fallback auf festen Pfad wie in der ersten Datei
                    local default_path = "${workspaceFolder}/build/mein_projekt.elf"
                    vim.notify("❌ Executable not found at: " .. full_path .. ", falling back to " .. default_path, vim.log.levels.WARN)
                    return vim.fn.input("Path to executable: ", default_path, "file")
                end
            end

            -- Funktion für :DapDebugWrite
            local function debug_write()
                if vim.fn.expand("%:e") ~= "c" and vim.fn.expand("%:e") ~= "cpp" then
                    vim.notify("❌ No C/C++ file open.", vim.log.levels.ERROR)
                    return
                end
                local file_dir = vim.fn.expand("%:p:h")
                local file_name = vim.fn.expand("%:t:r")
                local executable = file_dir .. "/" .. file_name
                if vim.fn.filereadable(executable) == 1 then
                    os.remove(executable)
                    vim.notify("🧹 Deleted old executable: " .. executable, vim.log.levels.INFO)
                end
                vim.cmd("w")
                local compile_cmd = "gcc -g " .. vim.fn.expand("%:p") .. " -o " .. executable
                local output = vim.fn.system(compile_cmd)
                if vim.v.shell_error == 0 then
                    vim.notify("✅ Compiled successfully: " .. executable, vim.log.levels.INFO)
                else
                    vim.notify("❌ Compilation failed:\n" .. output, vim.log.levels.ERROR)
                end
            end

            -- DAP Konfigurationen
            dap.configurations.c = {
                {
                    name = "Launch C",
                    type = "gdb",
                    request = "launch",
                    program = get_executable_path,
                    cwd = vim.fn.expand("%:p:h"),
                    stopAtEntry = true,
                },
                {
                    name = "Launch ARM",
                    type = "gdb_arm",
                    request = "launch",
                    program = get_executable_path, -- Dynamisch, mit Fallback auf mein_projekt.elf
                    cwd = "${workspaceFolder}",
                    stopAtEntry = true,
                    setupCommands = { -- Hinzugefügt aus der ersten Datei
                        { text = "target remote localhost:3333" },
                        { text = "load" },
                    },
                },
            }

            dap.configurations.cpp = dap.configurations.c

            dap.configurations.sh = {
                {
                    name = "Launch Bash",
                    type = "bashdb",
                    request = "launch",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    pathBashdb = "bash",
                    pathBashdbLib = "/usr/share/bashdb",
                    pathBash = "bash",
                    pathCat = "cat",
                    pathMkfifo = "mkfifo",
                    pathPkill = "",
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
                    program = get_executable_path,
                    cwd = "${workspaceFolder}",
                    args = { "--no-gui" },
                    stopAtEntry = false,
                },
            }

            -- Keybindings
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", ";b", dap.toggle_breakpoint, opts)
            vim.keymap.set("n", ";B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, opts)
            vim.keymap.set("n", ";dr", dap.repl.open, opts)
            vim.keymap.set("n", ";xb", dap.clear_breakpoints, opts)
            vim.keymap.set("n", ";c", dap.continue, opts)
            vim.keymap.set("n", ";s", dap.step_over, opts)
            vim.keymap.set("n", ";i", dap.step_into, opts)
            vim.keymap.set("n", ";o", dap.step_out, opts)
            vim.keymap.set("n", ";w", function()
                dapui.elements.watches.add()
            end, opts)
            vim.keymap.set("n", ";W", function()
                dapui.elements.watches.add()
            end, opts)
            vim.keymap.set("n", ";xw", function()
                dapui.elements.watches.remove()
            end, opts)
            vim.keymap.set("n", ";ew", function()
                dapui.elements.watches.edit()
            end, opts)
            vim.keymap.set("n", ";dw", debug_write, opts)
            vim.keymap.set("n", ";a", function()
                dap.run(dap.configurations.c[2]) -- Läuft "Launch ARM"
            end, opts)

            -- User Commands
            vim.api.nvim_create_user_command(
                "DapDebugWrite",
                debug_write,
                { desc = "Delete executable, save file, and compile with gcc" }
            )
            vim.api.nvim_create_user_command("DapSetWatches", function()
                dapui.elements.watches.add()
            end, { desc = "Add a watch" })
            vim.api.nvim_create_user_command("DapSetWatchesW", function()
                dapui.elements.watches.add()
            end, { desc = "Add a conditional watch" })
            vim.api.nvim_create_user_command("DapEditWatches", function()
                dapui.elements.watches.edit()
            end, { desc = "Edit watches" })
            vim.api.nvim_create_user_command("DapDeleteWatches", function()
                dapui.elements.watches.remove()
            end, { desc = "Remove watches" })
            vim.api.nvim_create_user_command("DapContinue", dap.continue, { desc = "Continue or start debugging" })
            vim.api.nvim_create_user_command("DapStepOver", dap.step_over, { desc = "Step over" })
            vim.api.nvim_create_user_command("DapStepInto", dap.step_into, { desc = "Step into" })
            vim.api.nvim_create_user_command("DapStepOut", dap.step_out, { desc = "Step out" })
            vim.api.nvim_create_user_command(
                "DapToggleBreakpoint",
                dap.toggle_breakpoint,
                { desc = "Toggle breakpoint" }
            )
            vim.api.nvim_create_user_command("DapSetBreakpoint", function(opts)
                dap.set_breakpoint(opts.args)
            end, { desc = "Set conditional breakpoint", nargs = "?" })
            vim.api.nvim_create_user_command(
                "DapClearBreakpoints",
                dap.clear_breakpoints,
                { desc = "Clear all breakpoints" }
            )
            vim.api.nvim_create_user_command("DapReplOpen", dap.repl.open, { desc = "Open DAP REPL" })
            vim.api.nvim_create_user_command("DapRunDebugScript", function()
                local debug_lua = vim.fn.expand("%:p:h") .. "/debug.lua"
                local ok, err = pcall(dofile, debug_lua)
                if not ok then
                    vim.notify("Fehler beim Ausführen von debug.lua: " .. err, vim.log.levels.ERROR)
                end
            end, { desc = "Run debug.lua in current directory" })

            vim.keymap.set("n", ";run", function()
                vim.cmd("DapRunDebugScript")
            end, { noremap = true, silent = true })

            -- DAP-UI Listeners
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.after.event_stopped["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.after.event_terminated["dapui_notify"] = function()
                vim.notify("Debugging session terminated.", vim.log.levels.INFO)
            end
            dap.listeners.after.event_exited["dapui_notify"] = function()
                vim.notify("Debugging session exited.", vim.log.levels.INFO)
            end

            require("nvim-dap-virtual-text").setup()
        end,
    },
}
