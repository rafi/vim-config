-- rafi.plugins.extras.lang.helm
--

LazyVim.on_very_lazy(function()
	vim.filetype.add({
		pattern = {
			['.*/templates/.*%.ya?ml'] = 'helm',
			['.*/templates/.*%.tpl'] = 'helm',
		},
	})
end)

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
}
