-- Tmux utilities
--

-- Open 'man tmux' in a vertical split with word under cursor.
local function open_doc()
	local cword = vim.fn.expand('<cword>')
	require('man').open_page(0, { silent = true }, { 'tmux' })
	vim.fn.search(cword)
end

vim.opt_local.iskeyword:append('-')

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
	.. (vim.b.undo_ftplugin ~= nil and ' | ' or '')
	.. 'setlocal iskeyword<'
	.. '| sil! nunmap <buffer> gK'

vim.keymap.set('n', 'gK', open_doc, { buffer = 0 })
