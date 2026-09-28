-- Floating statuslines
local pack = require('rafi.pack')

pack.on_event('FileType', function()
	vim.pack.add({ 'https://github.com/b0o/incline.nvim' })
	require('incline').setup({
		ignore = {
			filetypes = { 'gitcommit' },
		},
	})
end)
