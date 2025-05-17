return {
	-- Quality of life improvements
	{ "glacambre/firenvim",                 build = ":call firenvim#install(0)" },
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
		'norcalli/nvim-colorizer.lua',
		keys = { { "<leader>co", "<cmd>ColorizerToggle<cr>", desc = "[CO]lorizer toggle" } },
	},
	{
		'riodelphino/cheat.nvim',
		opts = {
			debug = false,   -- show debug msg (only for me)
			readonly = false, -- true | false  ... false for editable
			window = {
				default = 'float', -- float | vsplit | hsplit
				float = {
					width = 0.8, -- ratio for nvim window
					height = 0.9, -- ratio for nvim window
					signcolumn = false, -- true | false ... Show signcolumn or not
					number = true, -- true | false ... Show number or not
					border = 'single', -- 'none'  'single' | 'double' | 'rounded' | 'solid'
				},
				vsplit = {
					height = 0.3, -- ratio for nvim window
					position = 'bottom', -- bottom | top
					signcolumn = false, -- true | false ... Show signcolumn or not
					number = true, -- true | false ... Show number or not
				},
				hsplit = {
					width = 0.5, -- ratio for nvim window
					position = 'left', -- left | right
					signcolumn = false, -- true | false ... Show signcolumn or not
					number = true, -- true | false ... Show number or not
				},
			},
			file = {
				dir = '~/.config/nvim/cheatsheets', -- Cheatsheet directory
				prefix = '',        -- Cheatsheet file's prefix.
				ext = 'md',         -- Cheatsheet file's extension.
			},
			cheatsheets = {
				filetypes = {                   -- Open the specific cheatsheet by file pattern.
					lua = { '*.lua' },          -- will open 'lua.md' cheatsheet, if called on *.lua files
					vim = { '*.vim', '*.vifmrc' }, -- The key 'vim' is the surfix of filename. ex.) cheat-vim.md
					js = { '*.js', '*.mjs' },
					css = { '*.css', '*.scss', '*.sass' }, -- Multiple filetypes are allowed.
					md = { '*.md' },
					php = { '*.php' },
					html = { '*.html' },
					typst = { '*.typ', '*.typst' },
					latex = { '*.tex' },
					-- Add more filetypes settings here.
				},
			},
			keymaps = {
				close = 'q', -- The keymap to close current cheat sheet. '<ESC>' is also good
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
	{
		'chomosuke/typst-preview.nvim',
		ft = 'typst',
		version = '1.*',
		opts = {}, -- lazy.nvim will implicitly calls `setup {}`
	},
	{        -- Has a lot, worth checking git
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("mini.ai").setup()
			require("mini.comment").setup()
			require("mini.indentscope").setup()
			require("mini.cursorword").setup()
			require("mini.surround").setup()
			require("mini.pairs").setup()
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
