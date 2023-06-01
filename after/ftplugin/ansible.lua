-- Ansible utilities
--

-- Open ansible-doc in a vertical split with word under cursor.
local function open_doc()
	vim.cmd([[
		vertical split
		| execute('terminal PAGER=cat ansible-doc ' .. shellescape(expand('<cword>')))
		| setf man
		| wincmd p
	]])
end

-- Add '.' to iskeyword for ansible modules, e.g. ansible.builtin.copy
vim.opt_local.iskeyword:append('.')
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
	.. (vim.b.undo_ftplugin ~= nil and ' | ' or '')
	.. 'setlocal iskeyword<'

if vim.fn.executable('ansible-doc') then
	vim.keymap.set('n', 'gK', open_doc, { buffer = 0 })

	vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| sil! nunmap <buffer> gK'
end
