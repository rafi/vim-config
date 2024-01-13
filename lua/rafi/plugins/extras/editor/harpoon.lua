return {

	-- Marks for navigating your project
	{
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		-- stylua: ignore
		opts = {},
		keys = {
			{ 'ga', function() require('harpoon'):list():append() end, desc = 'Add location' },
			{ '<Leader>ua', 'ga', desc = 'Show character under cursor' },
			{ '<LocalLeader>1', function() require('harpoon'):list():select(1) end, desc = 'Harpoon select 1' },
			{ '<LocalLeader>2', function() require('harpoon'):list():select(2) end, desc = 'Harpoon select 2' },
			{ '<LocalLeader>3', function() require('harpoon'):list():select(3) end, desc = 'Harpoon select 3' },
			{ '<LocalLeader>4', function() require('harpoon'):list():select(4) end, desc = 'Harpoon select 4' },
			{ 'gzp', function() require('harpoon'):list():prev() end, desc = 'Previous location' },
			{ 'gzn', function() require('harpoon'):list():next() end, desc = 'Next location' },

			-- { '<LocalLeader>l', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = 'Toggle Harpoon list' },
			{ '<LocalLeader>l', function()
				local harpoon = require('harpoon')
				if not require('lazyvim.util').has('telescope.nvim') then
					harpoon.ui:toggle_quick_menu(harpoon:list())
					return
				end
				local conf = require('telescope.config').values
				local function toggle_telescope(harpoon_files)
					local file_paths = {}
					for _, item in ipairs(harpoon_files.items) do
						table.insert(file_paths, item.value)
					end

					require('telescope.pickers').new({}, {
						prompt_title = 'Harpoon',
						finder = require('telescope.finders').new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
						}):find()
				end
				toggle_telescope(harpoon:list())
			end, desc = 'List locations' },
		},
	},
}
