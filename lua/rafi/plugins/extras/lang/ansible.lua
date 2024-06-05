-- rafi.plugins.extras.lang.ansible
--

return {
	desc = 'Imports Ansible lang extras and adds more tools.',
	recommended = function()
		return LazyVim.extras.wants({
			ft = 'yaml.ansible',
			root = { 'ansible.cfg', '.ansible-lint' },
		})
	end,

	{ import = 'lazyvim.plugins.extras.lang.ansible' },

	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'pearofducks/ansible-vim',
			ft = { 'ansible', 'ansible_hosts', 'jinja2' },
		},
		opts = function(_, _)
			vim.filetype.add({
				pattern = {
					['.*/playbooks/.*%.ya?ml'] = 'yaml.ansible',
					['.*/roles/.*/tasks/.*%.ya?ml'] = 'yaml.ansible',
					['.*/roles/.*/handlers/.*%.ya?ml'] = 'yaml.ansible',
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

			-- Setup filetype settings
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_ftplugin_ansible', {}),
				pattern = 'ansible',
				callback = function()
					-- Add '.' to iskeyword for ansible modules, e.g. ansible.builtin.copy
					vim.opt_local.iskeyword:append('.')
					vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
						.. (vim.b.undo_ftplugin ~= nil and ' | ' or '')
						.. 'setlocal iskeyword<'

					if vim.fn.executable('ansible-doc') then
						vim.b.undo_ftplugin = vim.b.undo_ftplugin
							.. '| sil! nunmap <buffer> gK'
						vim.keymap.set('n', 'gK', function()
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
