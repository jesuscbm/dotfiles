return {
	-- Quality of life improvements
	{ "glacambre/firenvim", build = ":call firenvim#install(0)" },
	{ "lukas-reineke/indent-blankline.nvim" },
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("undotree").setup({
				float_diff = true, -- using float window previews diff, set this `true` will disable layout option
				layout = "left_bottom", -- "left_bottom", "left_left_bottom"
				position = "left", -- "right", "bottom"
				ignore_filetype = {
					"undotree",
					"undotreeDiff",
					"qf",
					"TelescopePrompt",
					"spectre_panel",
					"tsplayground",
				},
				window = {
					winblend = 30,
				},
				keymaps = {
					["j"] = "move_next",
					["k"] = "move_prev",
					["gj"] = "move2parent",
					["J"] = "move_change_next",
					["K"] = "move_change_prev",
					["<cr>"] = "action_enter",
					["p"] = "enter_diffbuf",
					["q"] = "quit",
				},
			})
		end,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undotree" },
		},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},
	{
		"max397574/colortils.nvim",
		cmd = "Colortils",
		keys = {
			{ "<leader>co", "<cmd>Colortils picker<cr>", desc = "[CO]lortils" },
		},
		config = function()
			require("colortils").setup({
				-- Register in which color codes will be copied
				register = "+",
				-- Preview for colors, if it contains `%s` this will be replaced with a hex color code of the color
				color_preview = "█ %s",
				-- The default in which colors should be saved
				-- This can be hex, hsl or rgb
				default_format = "hex",
				-- String: default color if no color is found
				default_color = "#000000",
				-- Border for the float
				border = "rounded",
				-- Some mappings which are used inside the tools
				mappings = {
					-- increment values
					increment = "l",
					-- decrement values
					decrement = "h",
					-- increment values with bigger steps
					increment_big = "L",
					-- decrement values with bigger steps
					decrement_big = "H",
					-- set values to the minimum
					min_value = "0",
					-- set values to the maximum
					max_value = "$",
					-- save the current color in the register specified above with the format specified above
					set_register_default_format = "<cr>",
					-- save the current color in the register specified above with a format you can choose
					set_register_choose_format = "g<cr>",
					-- replace the color under the cursor with the current color in the format specified above
					replace_default_format = "<m-cr>",
					-- replace the color under the cursor with the current color in a format you can choose
					replace_choose_format = "g<m-cr>",
					-- export the current color to a different tool
					export = "E",
					-- set the value to a certain number (done by just entering numbers)
					set_value = "c",
					-- toggle transparency
					transparency = "T",
					-- choose the background (for transparent colors)
					choose_background = "B",
					-- quit window
					quit_window = { "q", "<esc>" },
				},
			})
		end,
	},
	{
		"riodelphino/cheat.nvim",
		opts = {
			debug = false, -- show debug msg (only for me)
			readonly = false, -- true | false  ... false for editable
			window = {
				default = "float", -- float | vsplit | hsplit
				float = {
					width = 0.8, -- ratio for nvim window
					height = 0.9, -- ratio for nvim window
					signcolumn = false, -- true | false ... Show signcolumn or not
					number = true, -- true | false ... Show number or not
					border = "single", -- 'none'  'single' | 'double' | 'rounded' | 'solid'
				},
				vsplit = {
					height = 0.3, -- ratio for nvim window
					position = "bottom", -- bottom | top
					signcolumn = false, -- true | false ... Show signcolumn or not
					number = true, -- true | false ... Show number or not
				},
				hsplit = {
					width = 0.5, -- ratio for nvim window
					position = "left", -- left | right
					signcolumn = false, -- true | false ... Show signcolumn or not
					number = true, -- true | false ... Show number or not
				},
			},
			file = {
				dir = "~/.config/nvim/cheatsheets", -- Cheatsheet directory
				prefix = "", -- Cheatsheet file's prefix.
				ext = "md", -- Cheatsheet file's extension.
			},
			cheatsheets = {
				filetypes = { -- Open the specific cheatsheet by file pattern.
					lua = { "*.lua" }, -- will open 'lua.md' cheatsheet, if called on *.lua files
					vim = { "*.vim", "*.vifmrc" }, -- The key 'vim' is the surfix of filename. ex.) cheat-vim.md
					js = { "*.js", "*.mjs" },
					css = { "*.css", "*.scss", "*.sass" }, -- Multiple filetypes are allowed.
					md = { "*.md" },
					php = { "*.php" },
					html = { "*.html" },
					typst = { "*.typ", "*.typst" },
					latex = { "*.tex" },
					-- Add more filetypes settings here.
				},
			},
			keymaps = {
				close = "q", -- The keymap to close current cheat sheet. '<ESC>' is also good
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{ -- Has a lot, worth checking git
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("mini.ai").setup()
			require("mini.comment").setup()
			require("mini.indentscope").setup()
			require("mini.cursorword").setup()
			require("mini.surround").setup()
			require("mini.pairs").setup()
			require("mini.icons").setup()
			require("mini.files").setup({
				-- Default config
				content = {
					-- Predicate for which file system entries to show
					filter = nil,
					-- What prefix to show to the left of file system entry
					prefix = nil,
					-- In which order to show file system entries
					sort = nil,
				},

				-- Module mappings created only inside explorer.
				-- Use `''` (empty string) to not create one.
				mappings = {
					close = "q",
					go_in = "l",
					go_in_plus = "L",
					go_out = "h",
					go_out_plus = "H",
					mark_goto = "'",
					mark_set = "m",
					reset = "<BS>",
					reveal_cwd = "@",
					show_help = "g?",
					synchronize = "=",
					trim_left = "<",
					trim_right = ">",
				},

				-- General options
				options = {
					-- Whether to delete permanently or move into module-specific trash
					permanent_delete = true,
					-- Whether to use for editing directories
					use_as_default_explorer = true,
				},

				-- Customization of explorer windows
				windows = {
					-- Maximum number of windows to show side by side
					max_number = math.huge,
					-- Whether to show preview of file/directory under cursor
					preview = false,
					-- Width of focused window
					width_focus = 50,
					-- Width of non-focused window
					width_nofocus = 15,
					-- Width of preview window
					width_preview = 25,
				},
			})
			local isOpen = false
			vim.keymap.set("n", "<C-t>", function ()
				if (isOpen) then
					MiniFiles.close()
				else
					MiniFiles.open()
				end
				isOpen = not isOpen
			end, {desc = "Open mini.files UI"})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					-- Defaults
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = false, -- Auto close on trailing </
				},
				-- Also override individual filetype configs, these take priority.
				-- Empty by default, useful if one of the "opts" global settings
				-- doesn't work well in a specific filetype
				per_filetype = {
					["html"] = {
						-- enable_close = false
					},
				},
			})
		end,
	},
	{ "tpope/vim-sleuth" },
	{
		"folke/which-key.nvim", -- Shows available keymaps
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
