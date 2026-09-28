-- Marks for navigating your project
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/harpoon2.lua
local menu_width = vim.api.nvim_win_get_width(0) - 4

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- harpoon2 (the `harpoon2` branch) requires plenary.nvim (`plenary.path`)
	-- but doesn't declare it. Add it explicitly instead of relying on other
	-- core files happening to have added it first.
	vim.pack.add({
		'https://github.com/nvim-lua/plenary.nvim',
		{ src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
	})
	require('harpoon').setup({
		menu = { width = menu_width },
		settings = { save_on_toggle = true },
	})
end

-- Core keymaps (rafi.config.keymaps) map <localleader>h to Help Pages on
-- `later`, after this file runs. Re-apply on RafiKeymaps so harpoon wins,
-- while lua/config/keymaps.lua (which runs after) can still override it.
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = function()
		vim.keymap.set('n', '<localleader>h', function()
			load()
			local harpoon = require('harpoon')
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = 'List locations' })
	end,
})

-- stylua: ignore start
vim.keymap.set('n', '<leader>H', function() load() require('harpoon'):list():add() end, { desc = 'Add Location' })
vim.keymap.set('n', '<leader>mr', function() load() require('harpoon'):list():remove() end, { desc = 'Remove Location' })
vim.keymap.set('n', '<C-n>', function() load() require('harpoon'):list():next() end, { desc = 'Next Location' })
vim.keymap.set('n', '<C-p>', function() load() require('harpoon'):list():prev() end, { desc = 'Previous Location' })
-- stylua: ignore end

for i = 1, 5 do
	vim.keymap.set('n', '<localleader>' .. i, function()
		load()
		require('harpoon'):list():select(i)
	end, { desc = 'Harpoon to File ' .. i })
end
