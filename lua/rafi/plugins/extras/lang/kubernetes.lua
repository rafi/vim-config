-- rafi.plugins.extras.lang.kubernetes
--

return {
	desc = 'Imports YAML lang and adds common manifest patterns for schemas.',
	recommended = function()
		return LazyVim.extras.wants({ ft = 'yaml' })
	end,

	{ import = 'lazyvim.plugins.extras.lang.yaml' },

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				yamlls = {
					settings = {
						yaml = {
							completion = true,
							hover = true,
							schemas = {
								kubernetes = { 'k8s**.yaml', 'kube*/*.yaml' },
							},
						},
					},
				},
			},
		},
	},
}
