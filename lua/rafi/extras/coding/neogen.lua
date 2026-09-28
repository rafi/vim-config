-- Annotation generator
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/neogen.lua
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/danymat/neogen' })
	-- Setup creates the :Neogen command.
	require('neogen').setup({ snippet_engine = 'nvim' })
end)

vim.keymap.set('n', '<leader>cn', function()
	require('neogen').generate()
end, { desc = 'Generate Annotations (Neogen)' })
