-- Zettelkasten note-taking with the zk CLI
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/zk-org/zk-nvim' })
	-- `setup()` requires `zk.commands.builtin`, which registers commands and
	-- attaches its LSP client to the current buffer (and future ones via
	-- autocmd).
	require('zk').setup()
end

pack.on_filetype('markdown', load)

-- Stubs until `load()` defines the real commands.
pack.command(
	{ 'ZkNew', 'ZkNotes', 'ZkTags', 'ZkMatch' },
	load,
	{ nargs = '?', range = true }
)

-- NOTE: Conflict: org.obsidian, org.telekasten and org.vimwiki also map
-- `<leader>z*` keys.
local function map(lhs, mode, fn, desc)
	vim.keymap.set(mode or 'n', lhs, fn, { desc = desc })
end

map('<leader>zn', 'n', function()
	load()
	vim.cmd(('ZkNew { title = %s }'):format(vim.inspect(vim.fn.input('Title: '))))
end, 'Zk New')

map('<leader>zf', 'n', function()
	load()
	vim.cmd(
		("ZkNotes { sort = { 'modified' }, match = { %s } }"):format(
			vim.inspect(vim.fn.input('Search: '))
		)
	)
end, 'Zk Search')

-- An `expr` map returns the command to run after visual mode ends, when
-- the '< and '> marks are set. A plain callback runs while still in visual
-- mode, where they're unset (E20) or from the previous selection.
vim.keymap.set('x', '<leader>zg', function()
	load()
	return ":'<,'>ZkMatch<CR>"
end, { desc = 'Zk Match', expr = true })

-- stylua: ignore start
map('<leader>zo', 'n', function() load() vim.cmd([[ZkNotes { sort = { 'modified' } }]]) end, 'Zk Notes')
map('<leader>zt', 'n', function() load() vim.cmd('ZkTags') end, 'Zk Tags')
map('<leader>zb', 'n', function() load() vim.cmd('ZkBacklinks') end, 'Zk Backlinks')
map('<leader>zl', 'n', function() load() vim.cmd('ZkLinks') end, 'Zk Links')
map('<localleader>w', 'n', function() load() vim.cmd('ZkNotes') end, 'Zk notes')
-- stylua: ignore end
