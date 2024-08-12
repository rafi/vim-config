return {

	{
		'hrsh7th/nvim-cmp',
		optional = true,
		dependencies = { 'cmp-git' },
	},

	-- Git source for nvim-cmp
	{
		'petertriho/cmp-git',
		opts = {},
		config = function()
			local cmp = require('cmp')
			cmp.setup.filetype('gitcommit', {
				sources = cmp.config.sources({
					{ name = 'git', priority = 50 },
					{ name = 'path', priority = 40 },
				}, {
					{ name = 'buffer', priority = 50 },
				}),
			})
		end,
	},
}
