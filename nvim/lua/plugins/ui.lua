return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	-- Syntax highlighting and icons
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		disable = { "latex" },
		enable = true,

	},
	{ "nvim-tree/nvim-web-devicons" },

	-- UI enhancements
	{
		"rawrrawrpurpledinosaur/brainrot.nvim",
		config = function()
			require("brainrot").setup({ auto_play = false }) -- Enable auto-play on startup
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		lazy = false,
		event = "VimEnter",
		dependencies = "kevinhwang91/promise-async",
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
			for _, ls in ipairs(language_servers) do
				require("lspconfig")[ls].setup({
					capabilities = capabilities,
					-- you can add other fields for setting up lsp server in this table
				})
			end
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { 'lsp', 'indent' }
				end,
				open_fold_hl_timeout = 0, -- Disables highlighting on unfold
			})

			-- Option 3: treesitter as a main provider instead
			-- (Note: the `nvim-treesitter` plugin is *not* needed.)
			-- ufo uses the same query files for folding (queries/<lang>/folds.scm)
			-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
			-- require('ufo').setup({
			--     provider_selector = function(bufnr, filetype, buftype)
			--         return {'treesitter', 'indent'}
			--     end
			-- })
		end,
	},
	{ "nanozuki/tabby.nvim" },
	{ "romainl/vim-cool" }, -- Highlight search matches
	{
		"startup-nvim/startup.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" },
		config = function()
			require "startup".setup(require"startup-config")
		end
	},
}
