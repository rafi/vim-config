-- plugin: diffview.nvim
-- see: https://github.com/sindrets/diffview.nvim
-- rafi settings

local cb = require('diffview.config').diffview_callback
local lib = require('diffview.lib')

-- View entry without moving focus from explorer.
local function view_entry()
	local view = lib.get_current_view()
	if view and view.panel:is_open() then
		local file = view.panel:get_file_at_cursor()
		if file then
			view:set_file(file, false)
		end
	end
end

local function view_history_entry()
	local view = lib.get_current_view()
	if view.panel:is_cur_win() then
		local item = view.panel:get_item_at_cursor()
		if item then
			-- print(vim.inspect(item))
			if item.files then
				if view.panel.single_file then
					view:set_file(item.files[1], false)
				else
					view.panel:toggle_entry_fold(item)
				end
			else
				view:set_file(item, false)
			end
		end
	end
end

local function setup()
	vim.cmd [[
		augroup user-diffview
			autocmd!
			autocmd WinEnter,BufEnter diffview://* setlocal cursorline
			autocmd WinEnter,BufEnter diffview:///panels/* setlocal winhighlight=CursorLine:UserSelectionBackground
		augroup END
	]]

	require('diffview').setup{
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
				['l']       = '<cmd>lua require"plugins.diffview".view_entry()<CR>',
				['<cr>']    = '<cmd>lua require"plugins.diffview".view_entry()<CR>',
				['o']       = cb('select_entry'),
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
				['O']    = cb('options'),
				['l']    = '<cmd>lua require"plugins.diffview".view_history_entry()<CR>',
				['<cr>'] = '<cmd>lua require"plugins.diffview".view_history_entry()<CR>',
			},
			option_panel = {
				['<tab>'] = cb('select'),
				['q']     = cb('close'),
			},
		}
	}
end

return {
	setup = setup,
	view_entry = view_entry,
	view_history_entry = view_history_entry,
}

-- vim: set ts=2 sw=2 tw=80 noet :
