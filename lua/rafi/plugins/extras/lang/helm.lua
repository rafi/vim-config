-- rafi.plugins.extras.lang.helm
--

return {
	desc = 'Helm lang extras, common patterns, without towolf/vim-helm.',
	recommended = function()
		return LazyVim.extras.wants({
			ft = 'helm',
			root = { 'Chart.yaml' },
		})
	end,

	{ import = 'lazyvim.plugins.extras.lang.helm' },
	{ 'towolf/vim-helm', enabled = false },

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'helm', 'yaml' })
			end

			vim.filetype.add({
				pattern = {
					['.*/templates/.*%.ya?ml'] = 'helm',
					['.*/templates/.*%.tpl'] = 'helm',
				},
			})
		end,
	},
}
