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
				local scope = { scope = 'local', win = win }
				vim.api.nvim_set_option_value('spell', false, scope)
				vim.api.nvim_set_option_value('signcolumn', 'no', scope)
				vim.keymap.set('n', '<Esc>', '<cmd>quit<CR>')
			end,
		},
	},
}
