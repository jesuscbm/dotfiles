local vim = vim
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.cmd([[

filetype plugin indent on
syntax enable
packloadall
command Nigger wqa
command W w
command Wq wq
command WQ wq
command Q q

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

nmap <F8> :TagbarToggle<CR>

vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

map k gk
map j gj
]])

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>gq', function()
    vim.cmd([[silent! execute 'g/.\{80\}/normal gqq']])
end, { desc = 'Split long lines' })
vim.keymap.set('i', '<C-z>', '<C-o>u')
vim.keymap.set('i', '<C-y>', '<C-o><C-r>')

vim.cmd("nnoremap x \"_x")
-- Move lines
vim.cmd("nnoremap <silent> ñ :<C-u>call append(line(\".\"),   repeat([\"\"], v:count1))<CR>")
vim.cmd("nnoremap <silent> Ñ :<C-u>call append(line(\".\")-1, repeat([\"\"], v:count1))<CR>")

-- Delete without yank
vim.cmd("nnoremap x \"_x")
vim.cmd("nnoremap X \"_X")
vim.cmd("nnoremap C \"_C")
vim.cmd("nnoremap cc \"_cc")
vim.cmd("nnoremap x \"_x")

vim.keymap.set("x", "p", '"_dP', { desc = "Paste without overwriting register" })

vim.keymap.set("n", "çq", ":cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "çQ", ":cprev<CR>", { desc = "Previous quickfix item" })
vim.keymap.set("n", "ço", ":copen<CR>", { desc = "Open quickfix list" })
vim.keymap.set("n", "çc", ":cclose<CR>", { desc = "Close quickfix list" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


