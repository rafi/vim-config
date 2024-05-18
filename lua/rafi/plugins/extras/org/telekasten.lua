-- rafi.plugins.extras.org.telekasten
--

return {

	-- Manage text-based, markdown zettelkasten or wiki with telescope
	{
		'renerocksai/telekasten.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		cmd = { 'Telekasten' },
		-- stylua: ignore
		keys = {
			{ '<leader>zn', function() require('telekasten').new_note() end },
			{ '<leader>zN', function() require('telekasten').new_templated_note() end },
			{ '<leader>zf', function() require('telekasten').find_notes() end },
			{ '<leader>zg', function() require('telekasten').search_notes() end },
			{ '<leader>zo', function() require('telekasten').panel() end },
			{ '<leader>zt', function() require('telekasten').show_tags() end },
			{ '<leader>zd', function() require('telekasten').find_daily_notes() end },
			{ '<leader>zb', function() require('telekasten').show_backlinks() end },
			{ '<leader>zl', function() require('telekasten').find_friends() end },
			{ '<leader>zm', function() require('telekasten').browse_media() end },
		},
		opts = {
			home = vim.fn.expand('~/docs/wiki'),
		},
	},
}
