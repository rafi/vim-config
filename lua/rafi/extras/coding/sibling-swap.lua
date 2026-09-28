-- Swap sibling treesitter nodes
local pack = require('rafi.pack')

-- No setup needed, default keymaps are only created by setup().
pack.later(function()
	vim.pack.add({ 'https://github.com/Wansmer/sibling-swap.nvim' })
end)

vim.keymap.set('n', '<C-.>', function()
	require('sibling-swap').swap_with_right()
end)
vim.keymap.set('n', '<C-,>', function()
	require('sibling-swap').swap_with_left()
end)
