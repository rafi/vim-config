return {
	{
		'echasnovski/mini.map',
		keys = {
			{ '<Leader>mn', '<cmd>lua MiniMap.toggle()<CR>', desc = 'Mini map' },
		},
		opts = function()
			local minimap = require('mini.map')
			return {
				integrations = {
					minimap.gen_integration.diagnostic(),
					minimap.gen_integration.builtin_search(),
					minimap.gen_integration.gitsigns(),
				},
				window = { winblend = 50 },
			}
		end,
	},
}
