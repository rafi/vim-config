-- Man utilities
--

local opts = { noremap = true, silent = true, buffer = 0 }
vim.keymap.set('n', 'q', '<cmd>quit<CR>', opts)
vim.keymap.set('n', '<Leader>o', function()
	require('man').show_toc()
end, opts)

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '\n '
	.. 'sil! nunmap <buffer> <Leader>o'
	.. ' | sil! nunmap <buffer> q'
