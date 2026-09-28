-- Track and reuse file system visits
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/nvim-mini/mini.visits' })
	require('mini.visits').setup()
end)

-- Core keymaps (rafi.config.keymaps) map <localleader>h to Help Pages on
-- `later`, after this file runs. Re-apply on RafiKeymaps so Visits wins,
-- while lua/config/keymaps.lua (which runs after) can still override it.
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = function()
		vim.keymap.set(
			'n',
			'<localleader>h',
			'<cmd>lua MiniVisits.select_path()<CR>',
			{ desc = 'Visits' }
		)
	end,
})

-- Harpoon-like marks: files labeled "core" in the current cwd, sorted by
-- path so the numbered keys and next/prev keep a stable order (the default
-- sort reorders by visit recency and frequency).
local label = 'core'

local function sort_by_path(path_data)
	table.sort(path_data, function(a, b)
		return a.path < b.path
	end)
	return path_data
end

local function iterate(direction)
	MiniVisits.iterate_paths(
		direction,
		nil,
		{ filter = label, sort = sort_by_path, wrap = true }
	)
end

-- Open the i-th core path of the cwd, if there is one.
local function select(i)
	local paths =
		MiniVisits.list_paths(nil, { filter = label, sort = sort_by_path })
	if paths[i] then
		vim.cmd.edit(vim.fn.fnameescape(paths[i]))
	end
end

-- stylua: ignore start
vim.keymap.set('n', '<leader>H', function() MiniVisits.add_label(label) end, { desc = 'Add Location' })
vim.keymap.set('n', '<leader>mr', function() MiniVisits.remove_label(label) end, { desc = 'Remove Location' })
vim.keymap.set('n', '<C-n>', function() iterate('forward') end, { desc = 'Next Location' })
vim.keymap.set('n', '<C-p>', function() iterate('backward') end, { desc = 'Previous Location' })
-- stylua: ignore end

for i = 1, 5 do
	vim.keymap.set('n', '<localleader>' .. i, function()
		select(i)
	end, { desc = 'Visits to File ' .. i })
end
