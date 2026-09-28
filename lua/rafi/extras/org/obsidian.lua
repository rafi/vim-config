-- Obsidian vault notes: links, backlinks, dailies, templates
-- Command/keys-only: setup is required before its :Obsidian works.
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- Its plugin/ defines :Obsidian, replacing the stub below.
	vim.pack.add({ 'https://github.com/obsidian-nvim/obsidian.nvim' })
	---@module 'obsidian'
	---@type obsidian.config
	require('obsidian').setup({
		legacy_commands = false, -- this will be removed in the next major release
		workspaces = {
			{ name = 'notebook', path = '~/notebook' },
		},
	})
end

require('rafi.pack').command('Obsidian', load, {
	range = 2, -- same as the real :Obsidian
	complete = true,
})

-- NOTE: Conflict: org.telekasten and org.zk also map `<leader>z*` keys.
local function map(lhs, args, desc)
	vim.keymap.set('n', lhs, '<cmd>Obsidian ' .. args .. '<CR>', { desc = desc })
end

-- stylua: ignore start
map('<leader>zn', 'new', 'Obsidian new')
map('<leader>zN', 'new_from_template', 'Obsidian new (template)')
map('<leader>zg', 'search', 'Obsidian search')
map('<leader>zt', 'tags', 'Obsidian tags')
map('<leader>zb', 'backlinks', 'Obsidian backlinks')
map('<leader>zd', 'dailies', 'Obsidian dailies')
-- stylua: ignore end
