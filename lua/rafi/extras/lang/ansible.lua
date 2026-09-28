-- Ansible: nvim-ansible filetypes/ftplugin, ansiblels and ansible-lint
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/ansible.lua

-- Eager: ftdetect must be sourced before files are read, and `ansible` is
-- only required by <leader>ta.
vim.pack.add({ 'https://github.com/mfussenegger/nvim-ansible' })

vim.filetype.add({
	pattern = {
		['.*/inventory/.*%.ini'] = 'ansible_hosts',
	},
})

-- For pearofducks/ansible-vim syntax, if installed.
vim.g.ansible_extra_keywords_highlight = 1
vim.g.ansible_template_syntaxes = {
	['*.json.j2'] = 'json',
	['*.(ba)?sh.j2'] = 'sh',
	['*.ya?ml.j2'] = 'yaml',
	['*.xml.j2'] = 'xml',
	['*.conf.j2'] = 'conf',
	['*.ini.j2'] = 'ini',
}

require('rafi.util.lang').add({
	servers = { ansiblels = true },
	tools = { 'ansible-lint' },
})

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi.ftplugin.ansible', {}),
	pattern = 'yaml.ansible',
	callback = function(ev)
		vim.keymap.set('n', '<leader>ta', function()
			require('ansible').run()
		end, {
			buffer = ev.buf,
			silent = true,
			desc = 'Ansible Run Playbook/Role',
		})

		-- Checkout https://github.com/pearofducks/ansible-vim/blob/master/syntax/ansible_doc.vim
		-- Add '.' to iskeyword for ansible modules, e.g. ansible.builtin.copy
		vim.opt_local.iskeyword:append('.')
		vim.b[ev.buf].undo_ftplugin = (vim.b[ev.buf].undo_ftplugin or '')
			.. '\nsetlocal iskeyword<'
			.. '\nsil! nunmap <buffer> <leader>ta'

		if vim.fn.executable('ansible-doc') == 1 then
			vim.b[ev.buf].undo_ftplugin = vim.b[ev.buf].undo_ftplugin
				.. '\nsil! nunmap <buffer> <Leader>K'
			vim.keymap.set('n', '<Leader>K', function()
				-- Open ansible-doc in a vertical split with word under cursor.
				vim.cmd([[
					vertical split
					| execute('terminal PAGER=cat ansible-doc ' .. shellescape(expand('<cword>')))
					| setf man
					| wincmd p
				]])
			end, { buffer = ev.buf, desc = 'Ansible Doc' })
		end
	end,
})
