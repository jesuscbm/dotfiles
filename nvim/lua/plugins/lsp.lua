local vim = vim
return {
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			-- "WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,

			format_on_save = nil,
			formatters_by_ft = {
				lua = { "stylua" },
				cpp = { "clang_format" },
				c = { "clang_format" },
				python = { "pyink" },
				bash = { "beautysh" },
				sh = { "beautysh" },
				zsh = { "beautysh" },
				fish = { "beautysh" },
				csh = { "beautysh" },
				markdown = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				svelte = { "prettier" },
				-- java = {},
			},
		},
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",
			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					-- ['<C-n>'] = cmp.mapping.select_next_item(),
					["<C-Down>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					-- ['<C-p>'] = cmp.mapping.select_prev_item(),
					["<C-Up>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					-- ['<C-y>'] = cmp.mapping.confirm { select = true },

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					["<C-CR>"] = cmp.mapping.confirm({ select = true }),
					-- ["<Tab>"] = cmp.mapping.select_next_item(),
					-- ["<S-Tab>"] = cmp.mapping.select_prev_item(),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{
						name = "lazydev",
						-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
						group_index = 0,
					},
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "codeium" },
				},
			})
		end,
	},
	{ -- Shows diagnostics in a floating window
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{ -- DAP, debugging
		"mfussenegger/nvim-dap",
	},
	{ -- DAP UI
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup()
		end,
	},
	-- { -- DAP Virtual Text
	-- 	"theHamsta/nvim-dap-virtual-text",
	-- 	dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
	-- 	config = function()
	-- 		require("nvim-dap-virtual-text").setup({})
	-- 	end,
	-- },
	-- {
	-- 	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	-- },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-cmdline" },
	{
		"petertriho/cmp-git",
		dependencies = { "hrsh7th/nvim-cmp" },
		opts = {
			-- options go here
		},
		init = function()
			table.insert(require("cmp").get_config().sources, { name = "git" })
		end,
	},
	-- using lazy.nvim
	{
		"S1M0N38/love2d.nvim",
		event = "VeryLazy",
		opts = {
			-- this are the default values
			path_to_love_bin = "love",
			path_to_love_library = vim.fn.globpath(vim.o.runtimepath, "love2d/library"),
			restart_on_save = false,
		},
		keys = {
			{ "<leader>v", ft = "lua", desc = "LÖVE" },
			{ "<leader>vv", "<cmd>LoveRun<cr>", ft = "lua", desc = "Run LÖVE" },
			{ "<leader>vs", "<cmd>LoveStop<cr>", ft = "lua", desc = "Stop LÖVE" },
		},
	},
	{
		"akinsho/flutter-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		config = function()
			require("flutter-tools").setup({
				flutter_path = nil,
				-- flutter_lookup_cmd = "where flutter",
				-- fvm = false,
				widget_guides = { enabled = true },
				lsp = {
					settings = {
						showtodos = true,
						completefunctioncalls = true,
						analysisexcludedfolders = {
						},
						renamefileswithclasses = "prompt",
						updateimportsonrename = true,
						enablesnippets = true,
					},
				},
				-- debugger = {
				-- 	enabled = true,
				-- 	run_via_dap = true,
				-- 	exception_breakpoints = {},
				-- 	register_configurations = function(paths)
				-- 		local dap = require("dap")
				-- 		-- See also: https://github.com/akinsho/flutter-tools.nvim/pull/292
				-- 		dap.adapters.dart = {
				-- 			type = "executable",
				-- 			command = paths.flutter_bin,
				-- 			args = { "debug-adapter" },
				-- 		}
				-- 		dap.configurations.dart = {}
				-- 		require("dap.ext.vscode").load_launchjs()
				-- 	end,
				-- },
			})
		end,
	},
}
