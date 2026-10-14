-- Show context of the current function
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ui/treesitter-context.lua
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter-context' })
	require('treesitter-context').setup({ mode = 'cursor', max_lines = 3 })
end

pack.on_event('BufReadPost,BufNewFile', load)

Snacks.toggle({
	name = 'Treesitter Context',
	get = function()
		-- Starts enabled once a buffer is read.
		return not loaded or require('treesitter-context').enabled()
	end,
	set = function(state)
		load()
		local tsc = require('treesitter-context')
		if state then
			tsc.enable()
		else
			tsc.disable()
		end
	end,
}):map('<leader>ut')
