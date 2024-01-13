return {

	-- Marks for navigating your project
	{
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		opts = {},
		-- stylua: ignore
		keys = {
			{ '<Leader>ua', 'ga', desc = 'Show character under cursor' },
			{ 'ga', function() require('harpoon'):list():append() end, desc = 'Add location' },
			{ '<C-n>', function() require('harpoon'):list():next() end, desc = 'Next location' },
			{ '<C-p>', function() require('harpoon'):list():prev() end, desc = 'Previous location' },
			{ '<Leader>mr', function() require('harpoon'):list():remove() end, desc = 'Remove location' },
			{ '<LocalLeader>1', function() require('harpoon'):list():select(1) end, desc = 'Harpoon select 1' },
			{ '<LocalLeader>2', function() require('harpoon'):list():select(2) end, desc = 'Harpoon select 2' },
			{ '<LocalLeader>3', function() require('harpoon'):list():select(3) end, desc = 'Harpoon select 3' },
			{ '<LocalLeader>4', function() require('harpoon'):list():select(4) end, desc = 'Harpoon select 4' },

			{ '<LocalLeader>l', function()
				local harpoon = require('harpoon')
				if not require('lazyvim.util').has('telescope.nvim') then
					harpoon.ui:toggle_quick_menu(harpoon:list())
					return
				end
				return require('telescope._extensions.marks')()
			end, desc = 'List locations' },
		},
	},
}
