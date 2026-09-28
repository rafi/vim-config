-- Show next key clues, replaces which-key (mini.clue)
local pack = require('rafi.pack')

pack.later(function()
	if require('rafi.config').enabled('ui.which-key') then
		vim.notify(
			"ui.mini-clue: disable the 'ui.which-key' extra (:RafiExtras)",
			vim.log.levels.WARN
		)
	end
	vim.pack.add({ 'https://github.com/nvim-mini/mini.clue' })
	local miniclue = require('mini.clue')
	miniclue.setup({
		clues = {
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
end)
