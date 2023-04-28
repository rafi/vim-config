return {

	{
		'someone-stole-my-name/yaml-companion.nvim',
		dependencies = {
			'neovim/nvim-lspconfig',
			'nvim-telescope/telescope.nvim',
		},
		keys = {
			{ '<localleader>y', '<cmd>Telescope yaml_schema<CR>', desc = 'YAML Schema' },
		},
		config = function()
			require('telescope').load_extension('yaml_schema')
		end,
	},

}
