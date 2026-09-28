return {

	{ 'folke/which-key.nvim', enabled = false },

	-- Show next key clues
	{
		'nvim-mini/mini.clue',
		version = false,
		event = 'VeryLazy',
		opts = function(_, opts)
			local miniclue = require('mini.clue')
			opts = vim.tbl_deep_extend('keep', opts or {}, {
				clues = {
					-- Enhance this by adding descriptions for <Leader> mapping groups
					miniclue.gen_clues.builtin_completion(),
					miniclue.gen_clues.g(),
					miniclue.gen_clues.marks(),
					miniclue.gen_clues.registers(),
					miniclue.gen_clues.windows(),
					miniclue.gen_clues.z(),
				},
				triggers = {
					-- Leader triggers
					{ mode = 'n', keys = '<Leader>' },
					{ mode = 'x', keys = '<Leader>' },
					{ mode = 'n', keys = '<LocalLeader>' },
					{ mode = 'x', keys = '<LocalLeader>' },

					-- Built-in completion
					{ mode = 'i', keys = '<C-x>' },

					-- `g` key
					{ mode = 'n', keys = 'g' },
					{ mode = 'x', keys = 'g' },

					-- Marks
					{ mode = 'n', keys = "'" },
					{ mode = 'n', keys = '`' },
					{ mode = 'x', keys = "'" },
					{ mode = 'x', keys = '`' },

					-- Registers
					{ mode = 'n', keys = '"' },
					{ mode = 'x', keys = '"' },
					{ mode = 'i', keys = '<C-r>' },
					{ mode = 'c', keys = '<C-r>' },

					-- Window commands
					{ mode = 'n', keys = '<C-w>' },

					-- `z` key
					{ mode = 'n', keys = 'z' },
					{ mode = 'x', keys = 'z' },
				},
			})
			return opts
		end,
	},
}
