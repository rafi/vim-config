-- nvim-window-picker loader, shared by the core window-picker file and
-- plugins that pick windows through it (e.g. neo-tree's
-- `open_with_window_picker`), so both get the same filter rules.
-- https://github.com/rafi/vim-config

local M = {}

local loaded = false

-- Adds and sets up nvim-window-picker on first call, returns the module.
---@return table
function M.load()
	if not loaded then
		loaded = true
		vim.pack.add({ 'https://github.com/s1n7ax/nvim-window-picker' })
		require('window-picker').setup({
			hint = 'floating-big-letter',
			show_prompt = false,
			filter_rules = {
				include_current_win = true,
				autoselect_one = true,
				bo = {
					filetype = { 'neo-tree', 'neo-tree-popup', 'notify', 'noice' },
					buftype = { 'terminal', 'quickfix', 'prompt', 'nofile' },
				},
			},
		})
	end
	return require('window-picker')
end

return M
