-- plugin: diffview.nvim
-- see: https://github.com/sindrets/diffview.nvim
-- rafi settings

vim.cmd[[ autocmd! Diffview ]]

local cb = require('diffview.config').diffview_callback

require('diffview').setup{
	key_bindings = {
		view = {
			['<tab>']     = cb('select_next_entry'),
			['<s-tab>']   = cb('select_prev_entry'),
			[';a']        = cb('focus_files'),
			[';e']        = cb('toggle_files'),
			['q']         = '<cmd>DiffviewClose<CR>',
		},
		file_panel = {
			['q']         = '<cmd>DiffviewClose<CR>',
			['j']         = cb('next_entry'),
			['<down>']    = cb('next_entry'),
			['k']         = cb('prev_entry'),
			['<up>']      = cb('prev_entry'),
			['<cr>']      = cb('select_entry'),
			['o']         = cb('select_entry'),
			['R']         = cb('refresh_files'),
			['<c-r>']     = cb('refresh_files'),
			['<tab>']     = cb('select_next_entry'),
			['<s-tab>']   = cb('select_prev_entry'),
			[';a']        = cb('focus_files'),
			[';e']        = cb('toggle_files'),
		}
	}
}

-- vim: set ts=2 sw=2 tw=80 noet :
