-- Trailing whitespace highlight and remove
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvim-mini/mini.trailspace' })
	require('mini.trailspace').setup({})
end

pack.on_event('BufReadPost,BufNewFile', load)

vim.keymap.set('n', '<leader>cw', function()
	load()
	MiniTrailspace.trim()
end, { desc = 'Erase Whitespace' })
