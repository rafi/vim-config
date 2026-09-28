-- Visualize the undo history tree
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/mbbill/undotree' })
end)

vim.keymap.set(
	'n',
	'<leader>gu',
	'<cmd>UndotreeToggle<CR>',
	{ desc = 'Undo Tree' }
)
