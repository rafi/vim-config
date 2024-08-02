return {

	-- Bookmarks plugin with global file store
	{
		'tomasky/bookmarks.nvim',
		event = 'FileType',
		-- stylua: ignore
		keys = {
			{ 'mm', function() require('bookmarks').bookmark_toggle() end, desc = 'Toggle mark' },
			{ 'mi', function() require('bookmarks').bookmark_ann() end, desc = 'Annotate mark' },
			{ 'm<BS>', function() require('bookmarks').bookmark_clean() end, desc = 'Clean buffer marks' },
			{ 'm]', function() require('bookmarks').bookmark_next() end, desc = 'Jump to next mark' },
			{ 'm[', function() require('bookmarks').bookmark_prev() end, desc = 'Jump to previous mark' },
			{ 'ml', function() require('bookmarks').bookmark_list() end, desc = 'List marks' },
			{ 'm<Space>', function() require('bookmarks').bookmark_clear_all() end, desc = 'Remove all marks' },
		},
		opts = {
			save_file = vim.fn.stdpath('state') .. '/bookmarks.json',
			keywords = {
				['@t'] = ' ',
				['@w'] = ' ',
				['@f'] = '⛏ ',
				['@n'] = ' ',
			},
		},
	},
}
