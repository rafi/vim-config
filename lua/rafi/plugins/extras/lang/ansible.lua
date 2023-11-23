-- rafi.plugins.extras.lang.ansible
--

return {

	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'pearofducks/ansible-vim',
			ft = { 'ansible', 'ansible_hosts', 'jinja2' },
		},
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'yaml' })
			end

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

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				ansiblels = {},
			},
		},
	},

	{
		'mason.nvim',
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { 'ansible-lint' })
		end,
	},
}
