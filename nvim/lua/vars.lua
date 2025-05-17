local vim = vim
vim.o.showmatch = true --- Show matching brackets.
vim.o.ignorecase = true --- Do case insensitive matching
vim.o.smartcase = true --- Do smart case matching
vim.o.updatetime = 300
vim.o.autowrite = true --- Automatically save before commands like :next and :make
vim.o.hidden = true --- Hide buffers when they are abandoned
vim.o.mouse = "a" --- Enable mouse usage (all modes)
vim.o.nu = true ---line numbers
vim.o.smarttab = true ---Smart tab
vim.o.ai = true ---Auto indent
vim.o.si = true ---Smart indent
vim.cmd("noh")

-- Default tab settings
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.expandtab = false -- True to use space characters instead of tabs

vim.o.mat = 2
vim.o.ruler = true
vim.o.wildmenu = true
vim.o.magic = true

vim.schedule(function() -- Sync clipboard with OS
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true -- Indent wrapped lines
vim.opt.splitright = true -- How to vsplit
vim.opt.splitbelow = true -- How to split
vim.opt.undofile = true -- Save undo history
vim.opt.scrolloff = 7 -- Scroll when we are this much away from margins

vim.opt.showmode = false -- We show the mode with a statusline plugin
vim.g.have_nerd_font = true -- We are that much of a nerd

vim.opt.relativenumber = true

vim.g.swapfile = false
