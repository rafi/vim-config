-- Enhance Neovim's native comments with treesitter context
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })
	require('ts-comments').setup({})
end)
