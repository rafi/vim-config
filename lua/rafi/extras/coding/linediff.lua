-- Perform diffs on blocks of code
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/AndrewRadev/linediff.vim' })
end)

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map('x', '<leader>mdf', ':Linediff<CR>', 'Line diff')
map('x', '<leader>mda', ':LinediffAdd<CR>', 'Line diff add')
map('n', '<leader>mds', '<cmd>LinediffShow<CR>', 'Line diff show')
map('n', '<leader>mdr', '<cmd>LinediffReset<CR>', 'Line diff reset')
