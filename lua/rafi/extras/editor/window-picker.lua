-- Fancy window picker
local load = require('rafi.util.window_picker').load

vim.keymap.set('n', 'sp', function()
	local picked_window_id = load().pick_window()
	if picked_window_id ~= nil then
		vim.api.nvim_set_current_win(picked_window_id)
	end
end, { desc = 'Pick window' })

vim.keymap.set('n', 'sw', function()
	local picked_window_id = load().pick_window()
	if picked_window_id ~= nil then
		local current_winnr = vim.api.nvim_get_current_win()
		local current_bufnr = vim.api.nvim_get_current_buf()
		local other_bufnr = vim.api.nvim_win_get_buf(picked_window_id)
		vim.api.nvim_win_set_buf(current_winnr, other_bufnr)
		vim.api.nvim_win_set_buf(picked_window_id, current_bufnr)
	end
end, { desc = 'Swap picked window' })
