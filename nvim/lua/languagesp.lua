local vim = vim
--[[
require('java').setup({
    root_markers = {
        'settings.gradle',
        'settings.gradle.kts',
        'pom.xml',
        'build.gradle',
        'mvnw',
        'gradlew',
        'build.gradle',
        'build.gradle.kts',
        '.git',
    },
    cmd = { 'java' },
})
--]]

--  This function gets run when an LSP attaches to a particular buffer.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		-- NOTE: Remember that Lua is a real programming language, and as such it is possible
		-- to define small helper and utility functions so you don't have to repeat yourself.
		--
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

		-- Find references for the word under your cursor.
		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

		-- Jump to the type of the word under your cursor.
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

		-- Fuzzy find all the symbols in your current document.
		map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

		-- Fuzzy find all the symbols in your current workspace.
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		-- Rename the variable under your cursor.
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

		-- Execute a code action, usually your cursor needs to be on top of an error
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		map("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add [W]orksp[A]ce folder")
		map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove [W]o[R]kspace folder")
		map("<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "[W]orkspace [L]ist Folders")

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd("CursorHold", {
				callback = function()
					vim.diagnostic.open_float(nil, {
						focusable = false, -- Prevent the window from stealing focus
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" }, -- Close on these events
						-- border = "rounded", -- Optional: adds a rounded border to the popup
						source = "always", -- Show the source of the diagnostic
						prefix = "● ", -- Optional: adds a symbol as a prefix
					})
				end,
			})
			-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			-- 	buffer = event.buf,
			-- 	group = highlight_augroup,
			-- 	callback = vim.lsp.buf.document_highlight,
			-- })
			--
			-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			-- 	buffer = event.buf,
			-- 	group = highlight_augroup,
			-- 	callback = vim.lsp.buf.clear_references,
			-- })

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end
		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client then
			--and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint)--] then
			map("<leader>th", function()
				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				end
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- Change diagnostic symbols in the sign column (gutter)
if vim.g.have_nerd_font then
	local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
	local diagnostic_signs = {}
	for type, icon in pairs(signs) do
		diagnostic_signs[vim.diagnostic.severity[type]] = icon
	end
	vim.diagnostic.config({ signs = { text = diagnostic_signs } })
end

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
local servers = {
	clangd = {
		cmd = { "clangd", "--compile-commands-dir=.", "--extra-arg=-Iinclude" },
	},
	-- gopls = {},
	pyright = {},
	rust_analyzer = {},
	bashls = {},
	lua_ls = {
		-- cmd = { ... },
		-- filetypes = { ... },
		-- capabilities = {},
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT", -- Neovim uses LuaJIT
				},
				diagnostics = {
					globals = { "vim" }, -- Ignore 'undefined global vim'
				},
				workspace = {
					-- Path to your Addons directory
					userThirdParty = { os.getenv("HOME") .. ".local/share/LuaAddons" },
					checkThirdParty = "Apply",
				},
				telemetry = {
					enable = false, -- Disable telemetry data collection
				},
			},
		},
	},
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {})
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			local server = servers[server_name] or {}
			-- This handles overriding only values explicitly passed
			-- by the server configuration above. Useful when disabling
			-- certain features of an LSP (for example, turning off formatting for ts_ls)
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			require("lspconfig")[server_name].setup(server)
		end,
	},
	ensure_installed = ensure_installed,
	automatic_installation = true,
})

--[[
require('lspconfig').jdtls.setup({
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-23",
                        path = "/home/jesuscbm/jdk-23.0.2/",
                        default = true,
                    }
                }
            }
        }
    },
    handlers = {
        ['language/status'] = function(_, result)
            -- Print or whatever.
        end,
        ['$/progress'] = function(_, result, ctx)
            -- disable progress updates.
        end,
    },
})
--]]

require("typst-preview").setup({
	-- Setting this true will enable logging debug information to
	-- `vim.fn.stdpath 'data' .. '/typst-preview/log.txt'`
	debug = false,
	-- Custom format string to open the output link provided with %s
	open_cmd = '/usr/bin/librewolf "%s" > /dev/null',

	-- Custom port to open the preview server. Default is random.
	-- Example: port = 8000
	port = 0,

	-- Setting this to 'always' will invert black and white in the preview
	-- Setting this to 'auto' will invert depending if the browser has enable
	-- dark mode
	-- Setting this to '{"rest": "<option>","image": "<option>"}' will apply
	-- your choice of color inversion to images and everything else
	-- separately.
	invert_colors = "never",

	-- Whether the preview will follow the cursor in the source file
	follow_cursor = true,

	-- Provide the path to binaries for dependencies.
	-- Setting this will skip the download of the binary by the plugin.
	-- Warning: Be aware that your version might be older than the one
	-- required.
	dependencies_bin = {
		["tinymist"] = nil,
		["websocat"] = nil,
	},

	-- A list of extra arguments (or nil) to be passed to previewer.
	-- For example, extra_args = { "--input=ver=draft", "--ignore-system-fonts" }
	extra_args = nil,

	-- This function will be called to determine the root of the typst project
	get_root = function(path_of_main_file)
		local root = os.getenv("TYPST_ROOT")
		if root then
			return root
		end
		return vim.fn.fnamemodify(path_of_main_file, ":p:h")
	end,

	-- This function will be called to determine the main file of the typst
	-- project.
	get_main_file = function(path_of_buffer)
		return path_of_buffer
	end,
})

local config = require("fzf-lua.config")
local actions = require("trouble.sources.fzf").actions
config.defaults.actions.files["ctrl-t"] = actions.open

require("lspconfig").lua_ls.setup({})
