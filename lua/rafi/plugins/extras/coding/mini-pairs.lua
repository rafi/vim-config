return {

	{ 'windwp/nvim-autopairs', enabled = false },

	-- Automatically manage character pairs
	{
		'echasnovski/mini.pairs',
		event = 'VeryLazy',
		opts = {
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
			-- skip autopair when next character is closing pair
			-- and there are more closing pairs than opening pairs
			skip_unbalanced = true,
			-- better deal with markdown code blocks
			markdown = true,
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
		config = function(_, opts)
			LazyVim.mini.pairs(opts)
		end,
	},
}
