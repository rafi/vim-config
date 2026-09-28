-- Increment and decrement numbers, dates, and more
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/dial.lua
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/monaqa/dial.nvim' })
	require('rafi.util.dial').setup()
end)

-- Fall back to native keys if pressed before 'later' has run.
local function dial(increment, g)
	return function()
		if not package.loaded['dial.config'] then
			return (g and 'g' or '') .. (increment and '<C-a>' or '<C-x>')
		end
		return require('rafi.util.dial').dial(increment, g)
	end
end

-- stylua: ignore start
vim.keymap.set({ 'n', 'v' }, '<C-a>', dial(true), { expr = true, desc = 'Increment' })
vim.keymap.set({ 'n', 'v' }, '<C-x>', dial(false), { expr = true, desc = 'Decrement' })
vim.keymap.set({ 'n', 'x' }, 'g<C-a>', dial(true, true), { expr = true, desc = 'Increment' })
vim.keymap.set({ 'n', 'x' }, 'g<C-x>', dial(false, true), { expr = true, desc = 'Decrement' })
-- stylua: ignore end
