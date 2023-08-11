return {

	{
		'neovim/nvim-lspconfig',
		opts = {
			setup = {
				yamlls = function(_, _)
					local yamlls_opts = require('yaml-companion').setup(
						require('rafi.lib.utils').opts('yaml-companion.nvim')
					)
					require('lspconfig')['yamlls'].setup(yamlls_opts)
					return true
				end,
			},
		},
	},

	{
		'someone-stole-my-name/yaml-companion.nvim',
		dependencies = {
			'neovim/nvim-lspconfig',
			'nvim-telescope/telescope.nvim',
		},
		keys = {
			-- stylua: ignore
			{ '<localleader>y', '<cmd>Telescope yaml_schema<CR>', desc = 'YAML Schema' },
		},
		opts = {},
		config = function(_, _)
			require('telescope').load_extension('yaml_schema')
		end,
	},
}
