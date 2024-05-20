return {

	-- Marks for navigating your project
	{
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		opts = {},
		-- stylua: ignore
		keys = {
			{ '<Leader>ua', 'ga', desc = 'Show Character Under Cursor' },
			{ 'ga', function() require('harpoon'):list():add() end, desc = 'Add Location' },
			{ '<C-n>', function() require('harpoon'):list():next() end, desc = 'Next Location' },
			{ '<C-p>', function() require('harpoon'):list():prev() end, desc = 'Previous Location' },
			{ '<Leader>mr', function() require('harpoon'):list():remove() end, desc = 'Remove Location' },
			{ '<LocalLeader>1', function() require('harpoon'):list():select(1) end, desc = 'Harpoon to File 1' },
			{ '<LocalLeader>2', function() require('harpoon'):list():select(2) end, desc = 'Harpoon to File 2' },
			{ '<LocalLeader>3', function() require('harpoon'):list():select(3) end, desc = 'Harpoon to File 3' },
			{ '<LocalLeader>4', function() require('harpoon'):list():select(4) end, desc = 'Harpoon to File 4' },
			{ '<LocalLeader>5', function() require('harpoon'):list():select(5) end, desc = 'Harpoon to File 5' },

			{ '<LocalLeader>l', function()
				local harpoon = require('harpoon')
				if not LazyVim.has('telescope.nvim') then
					harpoon.ui:toggle_quick_menu(harpoon:list())
					return
				end
				return require('telescope._extensions.marks')()
			end, desc = 'List locations' },
		},
	},
}
