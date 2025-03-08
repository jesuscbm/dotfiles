local vim = vim

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true, -- Enable highlighting
		additional_vim_regex_highlighting = false, -- Disable regex fallback for better performance
	},
	auto_install = true, -- Auto-install missing parsers
})

vim.cmd([[ 

colorscheme lucid
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
highlight CodeiumSuggestion guifg=#808080 ctermfg=244

hi! Normal ctermbg=NONE guibg=NONE

:set completeopt-=preview " For No Previews

let g:indent_guides_enable_on_vim_startup = 1

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

let g:clang_library_path='/usr/lib/llvm-14/lib/libclang-14.so.1'

let g:blamer_enabled = 1
let g:blamer_prefix = ' > '
let g:blamer_delay = 1500
let g:blamer_show_in_insert_modes = 0
let g:blamer_show_in_visual_modes = 0

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = '🕮'
let g:airline_symbols.linenr = '|'

highlight LspInlayHint guifg=#70a0ff guibg=#202020
]])

vim.g.firenvim_config = {
	globalSettings = { alt = "all" },
	localSettings = {
		[".*"] = {
			cmdline = "neovim",
			-- content = "text",
			priority = 1,
			-- selector = "textare
			takeover = "never",
		},
	},
}


vim.o.foldcolumn = '0' -- '1' is not bad
-- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.opt.foldenable = false
vim.opt.foldlevel = 99

-- vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()' -- or a custom expression

-- Using ufo provider need remap `zR` and `zM`
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

vim.cmd("UfoAttach")
