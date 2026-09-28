-- Split and join blocks of code, using Tree-sitter
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/Wansmer/treesj' })
	-- Setup creates the real :TSJJoin/:TSJSplit commands, replacing the
	-- stubs below. use_default_keymaps=false: its defaults are global
	-- <Space>s/<Space>m/<Space>j, clobbering the <leader>s/<leader>m groups.
	require('treesj').setup({ use_default_keymaps = false })
end

pack.command('TSJJoin', load, { desc = 'Join Tree-sitter node' })
pack.command('TSJSplit', load, { desc = 'Split Tree-sitter node' })

-- stylua: ignore start
vim.keymap.set('n', 'sj', '<cmd>TSJJoin<CR>', { desc = 'Join Tree-sitter node' })
vim.keymap.set('n', 'sk', '<cmd>TSJSplit<CR>', { desc = 'Split Tree-sitter node' })
-- stylua: ignore end
