-- List buffers in a float window (flybuf.nvim)
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvimdev/flybuf.nvim' })
	require('flybuf').setup({})
end

pack.later(load)

vim.keymap.set('n', 'sf', function()
	load()
	require('flybuf').toggle()
end, { desc = 'Flybuf' })
