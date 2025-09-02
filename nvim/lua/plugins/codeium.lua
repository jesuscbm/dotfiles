return {
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({
				enable_cmp_source = false,
				enable_chat = true,
				virtual_text = {
					enabled = false,
					-- enabled = true,
					-- These are the defaults
					-- Set to true if you never want completions to be shown automatically.
					manual = false,
					-- A mapping of filetype to true or false, to enable virtual text.
					filetypes = {},
					default_filetype_enabled = true, -- True: blacklist filetypes, false: whitelist filetypes
					-- How long to wait (in ms) before requesting completions after typing stops.
					idle_delay = 75,
					-- Priority of the virtual text. This usually ensures that the completions appear on top of
					-- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
					-- desired.
					virtual_text_priority = 65535,
					-- Set to false to disable all key bindings for managing completions.
					map_keys = true,
					-- The key to press when hitting the accept keybinding but no completion is showing.
					-- Defaults to \t normally or <c-n> when a popup is showing.
					accept_fallback = nil,
					-- Key bindings for managing completions in virtual text mode.
					key_bindings = {
						-- Accept the current completion.
						accept = "<Tab>",
						-- Accept the next word.
						accept_word = false,
						-- Accept the next line.
						accept_line = false,
						-- Clear the virtual text.
						clear = "<C-u>",
						-- Cycle to the next completion.
						next = "<C-z>",
						-- Cycle to the previous completion.
						-- prev = "<M-[>",
						workspace_root = { use_lsp = true },
					}
				}
			})
			local codeium_notify = require("codeium.notify")

			codeium_notify.error = function(...) end
			codeium_notify.warn = function(...) end
		end
	},
}
