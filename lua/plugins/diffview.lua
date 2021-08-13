-- plugin: diffview.nvim
-- see: https://github.com/sindrets/diffview.nvim
-- rafi settings

local cb = require('diffview.config').diffview_callback
local lib = require('diffview.lib')

-- View entry without moving focus from explorer.
local function view_entry()
	local view = lib.get_current_diffview()
	if view and view.file_panel:is_open() then
		local file = view.file_panel:get_file_at_cursor()
		if file then view:set_file(file, false) end
	end
end

local function init()
	-- vim.cmd[[ autocmd! Diffview ]]
	vim.cmd [[
		autocmd BufWinEnter DiffviewFiles* setlocal winhighlight=CursorLine:UserSelectionBackground
	]]

	require('diffview').setup{
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
				['<cr>']    = '<cmd>lua require"plugins.diffview".view_entry()<CR>',
				['o']       = cb('select_entry'),
				['R']       = cb('refresh_files'),
				['<c-r>']   = cb('refresh_files'),
				['<tab>']   = cb('select_next_entry'),
				['<s-tab>'] = cb('select_prev_entry'),
				[';a']      = cb('focus_files'),
				[';e']      = cb('toggle_files'),
			}
		}
	}
end

return {
	init = init,
	view_entry = view_entry,
}

-- vim: set ts=2 sw=2 tw=80 noet :
