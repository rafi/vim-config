-- Ansible utilities

local function open_doc()
	vim.cmd([[
		vertical split
		| execute('terminal PAGER=cat ansible-doc ' .. shellescape(expand('<cword>')))
		| setf man
		| wincmd p
	]])
end

if vim.fn.executable('ansible-doc') then
	vim.keymap.set('n', 'gK', open_doc, { buffer = 0 })

	vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
		.. (vim.b.undo_ftplugin ~= nil and ' | ' or '')
		.. 'sil! nunmap <buffer> gK'
end
