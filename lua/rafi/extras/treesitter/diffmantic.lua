-- Semantic diff using Treesitter
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/HarshK97/diffmantic.nvim' })
	-- Setup only refreshes highlights on ColorScheme.
	require('diffmantic').setup({})
end)
