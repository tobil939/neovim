return {
	{
		"nvim-lua/plenary.nvim", -- Optional: Für bessere Buffer-Handling (falls später nötig)
		config = function()
			-- Funktion zur Anzeige der Hilfeseite
			local function show_help()
				local help_text = {
					"------ DAP Debugger -------------------------------------------------------",
					":DapDebugWrite           ;dw    - Delete executable, save file, and compile",
					":DapContinue             ;c     - Debugging starten oder fortsetzen",
					":DapStepOver             ;s     - Nächste Zeile (überspringt Funktionen)",
					":DapStepInto             ;i     - In Funktion eintreten",
					":DapStepOut              ;o     - Aus Funktion heraustreten",
					":DapToggleBreakpoint     ;b     - Breakpoint an/aus",
					":DapSetBreakpoint        ;B     - Bedingten Breakpoint setzen",
					":DapClearBreakpoints     ;xb    - Alle Breakpoints löschen",
					":DapReplOpen             ;dr    - REPL öffnen",
					":DapSetWatches           ;w     - Variable beobachten",
					":DapSetWatchesW          ;W     - Bedingte Variable beobachten",
					":DapEditWatches          ;ew    - Watches bearbeiten",
					":DapDeleteWatches        ;xw    - Watches löschen",
					"                         ;a     - ARM Debugging starten",
					" ",
					" ",
					"------ Formater und Linter -------------------------------------------------",
					"                        ;f      - Formatter Ausführen",
					"                        ;l      - Linter Ausführen",
					"                        ;de     - Diagnose aktiveren, Linter Meldungen anzeigen",
					"                        ;dd     - Diagnose deaktivieren",
					"                        [d      - vorheriger Punkt für Diagnose",
					"                        ]d      - nächster Puntk für Diagnose",
					" ",
					" ",
					"------ Rechtschreibprüfung -------------------------------------------------",
					":set spell                      - Rechtschreibprüfung an",
					":set nospell                    - Rechtschreibprüfung aus",
					"                        [s      - vorheriger Rechtschreibfehler",
					"                        ]s      - nächster Rechtschriebfehler",
					"                        z=      - Korrekturvorschläge",
					":set spelllang=de_de            - deutsches Wörterbuch",
					":set spelllang=en_us            - englisches Wörterbuch",
					":set spelllang?                 - wechles Wörterbuch ist ausgewählt?",
					" ",
					" ",
					"------ Suche ----------------------------------------------------------------",
					"/bunga                          - sucht nach dem nächsten bunga",
					"//                              - wiederholt Suche vorwärts",
					"?bunga                          - sucht nach dem vorherigen bunga",
					"??                              - wiederholt Suche rückwärts",
					"*                               - sucht Wort unter Cursor vorwärts",
					"#                               - sucht Wort unter Cursor rückwärts",
					"n                               - nächstes bunga wird angezeigt",
					"N                               - vorheriges bunga wird angezeigt",
					":noh                            - entfernt Markierung der Suche",
					" ",
					" ",
					"------ Ersetzen --------------------------------------------------------------",
					":%s/bunga/bungo/g               - ersetzt alle bunga durch bungo",
					":%s/bunga/bungo/gc              - frag jedes Mal nach",
					" ",
					" ",
					"------ Mehrere Zeilen bearbeiten ---------------------------------------------",
					"im visual mode zeilen markieren, : öffnet dann die Zeile :'<,'> ",
					":'<,'>s^#/                      - entfernt # am Anfang der Zeile",
					":'<,'>s^/#                      - fügt ein # am Anfang der Zeile ein",
					":'<,'>s$#/                      - entfernt # am Ende der Zeile",
					":'<,'>s$/#                      - fügt # am Ende der Zeile hinzu",
					" ",
					" ",
					"------ Nvim Tree ---------------------------------------------",
					"j                               - navigieren nach unten",
					"k                               - navigieren nach oben",
					"RETURN                          - aufklappen oder zuklappen",
					"d                               - Datei oder Ordner unter Cursor löschen",
					"r                               - Datei oder Ordner unter Cursor umbenennen",
					"a                               - Datei erstellen, bunga/ erstellt den Ordner bunga",
					" ",
					" ",
				}

				-- Finde den Index der Zeile "------ Suche ------"
				local split_index = 0
				for i, line in ipairs(help_text) do
					if line == "------ Suche ----------------------------------------------------------------" then
						split_index = i - 1 -- Teile vor dieser Zeile
						break
					end
				end
				if split_index == 0 then
					split_index = math.floor(#help_text / 2) -- Fallback, falls nicht gefunden
				end

				-- Teile die Liste
				local left_text = { unpack(help_text, 1, split_index) }
				local right_text = { unpack(help_text, split_index + 1, #help_text) }

				-- Berechne Fenstergrößen
				local total_width = vim.api.nvim_get_option("columns")
				local window_width = math.floor(total_width / 2) - 2 -- Platz zwischen Fenstern
				local max_height = math.max(#left_text, #right_text) + 2

				-- Erstelle Buffer für linkes und rechtes Fenster
				local left_buf = vim.api.nvim_create_buf(false, true)
				local right_buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(left_buf, 0, -1, false, left_text)
				vim.api.nvim_buf_set_lines(right_buf, 0, -1, false, right_text)

				-- Fenster-Optionen für linkes Fenster
				local left_win_opts = {
					relative = "editor",
					width = window_width,
					height = max_height,
					col = 0, -- Links am Rand
					row = math.floor((vim.api.nvim_get_option("lines") - max_height) / 2),
					style = "minimal",
					border = "single",
				}

				-- Fenster-Optionen für rechtes Fenster
				local right_win_opts = {
					relative = "editor",
					width = window_width,
					height = max_height,
					col = window_width + 2, -- Rechts vom linken Fenster
					row = math.floor((vim.api.nvim_get_option("lines") - max_height) / 2),
					style = "minimal",
					border = "single",
				}

				-- Öffne die Fenster
				local left_win = vim.api.nvim_open_win(left_buf, true, left_win_opts)
				local right_win = vim.api.nvim_open_win(right_buf, false, right_win_opts)

				-- Keybindings zum Schließen beider Fenster
				local function close_both_windows()
					vim.api.nvim_buf_delete(left_buf, { force = true })
					vim.api.nvim_buf_delete(right_buf, { force = true })
				end

				for _, buf in ipairs({ left_buf, right_buf }) do
					vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
						noremap = true,
						silent = true,
						callback = close_both_windows,
					})
					vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", {
						noremap = true,
						silent = true,
						callback = close_both_windows,
					})
					vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
					vim.api.nvim_buf_set_option(buf, "filetype", "help")
				end
			end

			-- Benutzerkommando erstellen
			vim.api.nvim_create_user_command("Help", show_help, { desc = "Show custom help page" })

			-- Keybinding für die Hilfeseite
			vim.keymap.set("n", "<leader>h", ":Help<CR>", { desc = "Show help page" })
		end,
	},
}
