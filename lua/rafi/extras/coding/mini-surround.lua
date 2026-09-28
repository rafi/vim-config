-- Fast and feature-rich surround actions
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/mini-surround.lua
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/nvim-mini/mini.surround' })
	require('mini.surround').setup({
		mappings = {
			add = 'sa', -- Add surrounding in Normal and Visual modes
			delete = 'ds', -- Delete surrounding
			find = 'gzf', -- Find surrounding (to the right)
			find_left = 'gzF', -- Find surrounding (to the left)
			highlight = 'gzh', -- Highlight surrounding
			replace = 'cs', -- Replace surrounding
		},
	})
	-- Upstream dropped the `update_n_lines` mapping, so map it here.
	vim.keymap.set('n', 'gzn', function()
		MiniSurround.update_n_lines()
	end, { desc = 'Update `MiniSurround.config.n_lines`' })
end)
