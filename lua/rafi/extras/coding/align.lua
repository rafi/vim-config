-- Align text interactively
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/nvim-mini/mini.align' })
	require('mini.align').setup({
		mappings = {
			start = 'gb',
			start_with_preview = 'gB',
		},
	})
end)
