-- plugin: goto-preview
-- see: https://github.com/rmagatti/goto-preview
-- rafi settings

require('goto-preview').setup {
	-- debug = false,
	width = 78,
	height = 15,
	default_mappings = false,
	opacity = 10,
	post_open_hook = function(_, win)
		vim.api.nvim_win_set_config(win, {
			border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'},
		})
		vim.api.nvim_win_set_option(win, 'spell', false)
		vim.api.nvim_win_set_option(win, 'signcolumn', 'no')
	end,
}
