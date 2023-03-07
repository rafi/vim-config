-- plugin: diffview.nvim
-- see: https://github.com/sindrets/diffview.nvim
-- rafi settings

local cb = require('diffview.config').diffview_callback

local function setup()
	vim.cmd [[
		augroup user-diffview
			autocmd!
			autocmd WinEnter,BufEnter diffview://* setlocal cursorline
			autocmd WinEnter,BufEnter diffview:///panels/* setlocal winhighlight=CursorLine:WildMenu
		augroup END
	]]

	require('diffview').setup({
		enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
		key_bindings = {
			view = {
				['q']         = '<cmd>DiffviewClose<CR>',
				['<tab>']     = cb('select_next_entry'),
				['<s-tab>']   = cb('select_prev_entry'),
				[';a']        = cb('focus_files'),
				[';e']        = cb('toggle_files'),
			},
			file_panel = {
				['q']       = '<cmd>DiffviewClose<CR>',
				['j']       = cb('next_entry'),
				['<down>']  = cb('next_entry'),
				['k']       = cb('prev_entry'),
				['<up>']    = cb('prev_entry'),
				['h']       = cb('prev_entry'),
				['l']       = cb('select_entry'),
				['<cr>']    = cb('select_entry'),
				['o']       = cb('focus_entry'),
				['gf']      = cb('goto_file'),
				['sg']      = cb('goto_file_split'),
				['st']      = cb('goto_file_tab'),
				['r']       = cb('refresh_files'),
				['R']       = cb('refresh_files'),
				['<c-r>']   = cb('refresh_files'),
				['<tab>']   = cb('select_next_entry'),
				['<s-tab>'] = cb('select_prev_entry'),
				[';a']      = cb('focus_files'),
				[';e']      = cb('toggle_files'),
			},
			file_history_panel = {
				['o']    = cb('focus_entry'),
				['l']    = cb('select_entry'),
				['<cr>'] = cb('select_entry'),
				['O']    = cb('options'),
			},
			option_panel = {
				['<tab>'] = cb('select'),
				['q']     = cb('close'),
			},
		}
	})
end

return {
	setup = setup,
}

-- vim: set ts=2 sw=2 tw=80 noet :
