-- Tabpage interface for cycling through diffs
if vim.fn.executable('git') == 0 then
	return
end

local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/sindrets/diffview.nvim' })
	local actions = require('diffview.actions')
	require('diffview').setup({
		enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
		keymaps = {
			view = {
				{ 'n', 'q', actions.close },
				{ 'n', '<Tab>', actions.select_next_entry },
				{ 'n', '<S-Tab>', actions.select_prev_entry },
				{ 'n', '<localleader>a', actions.focus_files },
				{ 'n', '<localleader>e', actions.toggle_files },
			},
			file_panel = {
				{ 'n', 'q', actions.close },
				{ 'n', 'h', actions.prev_entry },
				{ 'n', 'o', actions.focus_entry },
				{ 'n', 'gf', actions.goto_file },
				{ 'n', 'sg', actions.goto_file_split },
				{ 'n', 'st', actions.goto_file_tab },
				{ 'n', '<C-r>', actions.refresh_files },
				{ 'n', '<localleader>e', actions.toggle_files },
			},
			file_history_panel = {
				{ 'n', 'q', '<cmd>DiffviewClose<CR>' },
				{ 'n', 'o', actions.focus_entry },
				{ 'n', 'O', actions.options },
			},
		},
	})
end

pack.later(load)

-- Stubs until the plugin loads, e.g. `nvim +DiffviewOpen`.
pack.command(
	{ 'DiffviewOpen', 'DiffviewFileHistory' },
	load,
	{ desc = 'Diffview' }
)

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
	group = vim.api.nvim_create_augroup('rafi.diffview', {}),
	pattern = 'diffview:///panels/*',
	callback = function()
		vim.opt_local.cursorline = true
		vim.opt_local.winhighlight = 'CursorLine:WildMenu'
	end,
})

vim.keymap.set(
	'n',
	'<leader>gD',
	'<cmd>DiffviewFileHistory %<CR>',
	{ desc = 'Diff File' }
)
vim.keymap.set(
	'n',
	'<leader>gv',
	'<cmd>DiffviewOpen<CR>',
	{ desc = 'Diff View' }
)
