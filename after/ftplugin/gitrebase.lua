-- Git-rebase utilities
--

-- Set key-mappings.

local opts = { noremap = true, silent = true, buffer = 0 }
vim.keymap.set('n', 'q', '<cmd>quit<CR>', opts)

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '\nsil! nunmap <buffer> q'

if vim.fn.exists(':Cycle') > 0 then
	vim.keymap.set('n', '<Tab>', ':<C-U><C-R>=v:count1<CR>Cycle<CR>', opts)
	vim.keymap.set('n', '<S-Tab>', ':<C-U><C-R>=v:count1<CR>Cycle!<CR>', opts)

	vim.b.undo_ftplugin = vim.b.undo_ftplugin
		.. '\nsil! nunmap <buffer> <Tab>'
		.. '\nsil! nunmap <buffer> <S-Tab>'
end
