-- rafi.plugins.extras.lang.ansible
--

LazyVim.on_very_lazy(function()
	vim.filetype.add({
		pattern = {
			['.*/inventory/.*%.ini'] = 'ansible_hosts',
		},
	})

	vim.g.ansible_extra_keywords_highlight = 1
	vim.g.ansible_template_syntaxes = {
		['*.json.j2'] = 'json',
		['*.(ba)?sh.j2'] = 'sh',
		['*.ya?ml.j2'] = 'yaml',
		['*.xml.j2'] = 'xml',
		['*.conf.j2'] = 'conf',
		['*.ini.j2'] = 'ini',
	}
end)

return {
	desc = 'ansiblels, ansible-lint, mfussenegger/nvim-ansible',
	recommended = function()
		return LazyVim.extras.wants({
			ft = 'yaml.ansible',
			root = { 'ansible.cfg', '.ansible-lint' },
		})
	end,

	{
		'mason-org/mason.nvim',
		opts = { ensure_installed = { 'ansible-lint' } },
	},

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				ansiblels = {},
			},
		},
	},

	{
		'mfussenegger/nvim-ansible',
		ft = { 'yaml' },
		keys = {
			{
				'<leader>ta',
				function()
					require('ansible').run()
				end,
				ft = 'yaml.ansible',
				desc = 'Ansible Run Playbook/Role',
				silent = true,
			},
		},
		init = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi.ftplugin.ansible', {}),
				pattern = 'yaml.ansible',
				callback = function()
					-- Add '.' to iskeyword for ansible modules, e.g. ansible.builtin.copy
					vim.opt_local.iskeyword:append('.')
					vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '\n '
						.. 'setlocal iskeyword<'

					if vim.fn.executable('ansible-doc') then
						vim.b.undo_ftplugin = vim.b.undo_ftplugin
							.. '| sil! nunmap <buffer> <Leader>K'
						vim.keymap.set('n', '<Leader>K', function()
							-- Open ansible-doc in a vertical split with word under cursor.
							vim.cmd([[
								vertical split
								| execute('terminal PAGER=cat ansible-doc ' .. shellescape(expand('<cword>')))
								| setf man
								| wincmd p
							]])
						end, { buffer = 0 })
					end
				end,
			})
		end,
	},
}
