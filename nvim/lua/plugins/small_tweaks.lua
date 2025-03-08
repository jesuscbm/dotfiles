return {
	-- Quality of life improvements
	{ "glacambre/firenvim",                 build = ":call firenvim#install(0)" },
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "lervag/vimtex" },
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
		"sudormrfbin/cheatsheet.nvim",

		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
			{ "nvim-lua/popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			require("cheatsheet").setup({
				-- Whether to show bundled cheatsheets

				-- For generic cheatsheets like default, unicode, nerd-fonts, etc
				-- bundled_cheatsheets = {
				--     enabled = {},
				--     disabled = {},
				-- },
				bundled_cheatsheets = true,

				-- For plugin specific cheatsheets
				-- bundled_plugin_cheatsheets = {
				--     enabled = {},
				--     disabled = {},
				-- }
				bundled_plugin_cheatsheets = true,

				-- For bundled plugin cheatsheets, do not show a sheet if you
				-- don't have the plugin installed (searches runtimepath for
				-- same directory name)
				include_only_installed_plugins = true,

				-- Key mappings bound inside the telescope window
				telescope_mappings = {
					["<CR>"] = require("cheatsheet.telescope.actions").select_or_fill_commandline,
					["<A-CR>"] = require("cheatsheet.telescope.actions").select_or_execute,
					["<C-Y>"] = require("cheatsheet.telescope.actions").copy_cheat_value,
					["<C-E>"] = require("cheatsheet.telescope.actions").edit_user_cheatsheet,
				},
			})
		end,
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
