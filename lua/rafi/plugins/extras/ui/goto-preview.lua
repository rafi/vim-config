return {

	{
		'rmagatti/goto-preview',
		dependencies = 'nvim-telescope/telescope.nvim',
		keys = {
			{
				'gpd',
				function()
					require('goto-preview').goto_preview_definition({})
				end,
				{ noremap = true },
			},
			{
				'gpi',
				function()
					require('goto-preview').goto_preview_implementation({})
				end,
				{ noremap = true },
			},
			{
				'gpc',
				function()
					require('goto-preview').close_all_win()
				end,
				{ noremap = true },
			},
			{
				'gpr',
				function()
					require('goto-preview').goto_preview_references({})
				end,
				{ noremap = true },
			},
		},
		opts = {
			width = 78,
			height = 15,
			default_mappings = false,
			opacity = 10,
			post_open_hook = function(_, win)
				vim.api.nvim_win_set_config(win, {
					border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
				})
				vim.api.nvim_win_set_option(win, 'spell', false)
				vim.api.nvim_win_set_option(win, 'signcolumn', 'no')
				vim.keymap.set('n', '<Esc>', '<cmd>quit<CR>')
			end,
		},
	},

}
