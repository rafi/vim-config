-- Split and join arguments
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvim-mini/mini.splitjoin' })
	require('mini.splitjoin').setup({
		mappings = { toggle = '' },
	})
end

pack.later(load)

vim.keymap.set({ 'n', 'x' }, 'sj', function()
	load()
	MiniSplitjoin.join()
end, { desc = 'Join arguments' })

vim.keymap.set({ 'n', 'x' }, 'sk', function()
	load()
	MiniSplitjoin.split()
end, { desc = 'Split arguments' })
