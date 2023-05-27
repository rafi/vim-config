return {
	{
		'ghillb/cybu.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
		keys = {
			{ '[b', '<Plug>(CybuPrev)' },
			{ ']b', '<Plug>(CybuNext)' },
			{ '<C-S-Tab>', '<Plug>(CybuLastusedPrev)' },
			{ '<C-Tab>', '<Plug>(CybuLastusedNext)' },
		},
		config = true,
	},
	{
		'echasnovski/mini.bracketed',
		optional = true,
		opts = function(_, opts)
			opts.buffer = { suffix = '' }
			return opts
		end,
	},
}
