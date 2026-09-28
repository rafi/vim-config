-- Find And Replace plugin for neovim
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua
local pack = require('rafi.pack')

-- Read by the plugin on first use, no setup() needed.
vim.g.grug_far = { headerMaxWidth = 80 }

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- Sources plugin/grug-far.lua, which creates :GrugFar and :GrugFarWithin.
	vim.pack.add({ 'https://github.com/MagicDuck/grug-far.nvim' })
end

pack.later(load)

vim.keymap.set({ 'n', 'x' }, '<leader>sr', function()
	load()
	local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
	require('grug-far').open({
		transient = true,
		prefills = {
			filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
		},
	})
end, { desc = 'Search and Replace' })
