-- Man utilities
--

local opts = { noremap = true, silent = true, buffer = 0 }
local wincmd = vim.b.pager and 'q' or 'c'
vim.keymap.set('n', 'q', '<cmd>lclose<CR><C-W>' .. wincmd, opts)
vim.keymap.set('n', '<Leader>o', function()
	require('man').show_toc()
end, opts)

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
	.. (vim.b.undo_ftplugin ~= nil and ' | ' or '')
	.. 'sil! nunmap <buffer> <Leader>o'
	.. ' | sil! xunmap <buffer> q'
