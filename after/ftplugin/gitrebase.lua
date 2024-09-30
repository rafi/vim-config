-- Git-rebase utilities
--

local function setup_undo()
	vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '\n '
		.. 'sil! nunmap <buffer> <Tab>'
		.. ' | sil! nunmap <buffer> <S-Tab>'
end

-- Set key-mappings.
if vim.fn.exists(':Cycle') > 0 then
	local opts = { noremap = true, silent = true, buffer = 0 }
	vim.keymap.set('n', '<Tab>', ':<C-U><C-R>=v:count1<CR>Cycle<CR>', opts)
	vim.keymap.set('n', '<S-Tab>', ':<C-U><C-R>=v:count1<CR>Cycle!<CR>', opts)
	setup_undo()
end
