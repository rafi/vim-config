-- Markdown zettelkasten or wiki with telescope (telekasten.nvim)

local loaded = false
local function load()
	if not loaded then
		loaded = true
		vim.pack.add({
			'https://github.com/nvim-lua/plenary.nvim',
			'https://github.com/nvim-telescope/telescope.nvim',
			'https://github.com/nvim-telekasten/telekasten.nvim',
		})
		require('telekasten').setup({
			home = vim.fn.expand('~/notebook'),
		})
	end
	return require('telekasten')
end

-- Stub until setup() defines the real command.
require('rafi.pack').command('Telekasten', load)

-- NOTE: Conflict: org.obsidian, org.vimwiki and org.zk also map `<leader>z*`
-- keys.
-- stylua: ignore start
vim.keymap.set('n', '<leader>zn', function() load().new_note() end, { desc = 'New note' })
vim.keymap.set('n', '<leader>zN', function() load().new_templated_note() end, { desc = 'New templated note' })
vim.keymap.set('n', '<leader>zf', function() load().find_notes() end, { desc = 'Find notes' })
vim.keymap.set('n', '<leader>zg', function() load().search_notes() end, { desc = 'Search notes' })
vim.keymap.set('n', '<leader>zo', function() load().panel() end, { desc = 'Telekasten panel' })
vim.keymap.set('n', '<leader>zt', function() load().show_tags() end, { desc = 'Show tags' })
vim.keymap.set('n', '<leader>zd', function() load().find_daily_notes() end, { desc = 'Daily notes' })
vim.keymap.set('n', '<leader>zb', function() load().show_backlinks() end, { desc = 'Backlinks' })
vim.keymap.set('n', '<leader>zl', function() load().find_friends() end, { desc = 'Find friends' })
vim.keymap.set('n', '<leader>zm', function() load().browse_media() end, { desc = 'Browse media' })
-- stylua: ignore end
