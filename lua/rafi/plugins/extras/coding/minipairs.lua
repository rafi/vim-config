return {

	{ 'windwp/nvim-autopairs', enabled = false },

	-- Automatically manage character pairs
	{
		'echasnovski/mini.pairs',
		event = 'VeryLazy',
		opts = {
			mappings = {
				['`'] = {
					action = 'closeopen',
					pair = '``',
					neigh_pattern = '[^\\`].',
					register = { cr = false },
				},
			},
		},
		keys = {
			{
				'<leader>up',
				function()
					local Util = require('lazy.core.util')
					vim.g.minipairs_disable = not vim.g.minipairs_disable
					if vim.g.minipairs_disable then
						Util.warn('Disabled auto pairs', { title = 'Option' })
					else
						Util.info('Enabled auto pairs', { title = 'Option' })
					end
				end,
				desc = 'Toggle Auto Pairs',
			},
		},
	},
}
