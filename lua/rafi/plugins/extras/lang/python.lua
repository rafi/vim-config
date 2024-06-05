-- rafi.plugins.extras.lang.python
--

return {
	desc = 'Imports Python lang extras with more patterns and syntaxs.',
	recommended = function()
		return LazyVim.extras.wants({
			ft = 'python',
			root = {
				'pyproject.toml',
				'setup.py',
				'setup.cfg',
				'requirements.txt',
				'Pipfile',
				'pyrightconfig.json',
			},
		})
	end,

	{ import = 'lazyvim.plugins.extras.lang.python' },

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(
					opts.ensure_installed,
					{ 'ninja', 'python', 'pymanifest', 'requirements', 'rst', 'toml' }
				)
			end

			vim.filetype.add({
				filename = {
					['dev-requirements.txt'] = 'requirements',
				},
				pattern = {
					['requirements-.*%.txt'] = 'requirements',
				},
			})
		end,
	},
}
