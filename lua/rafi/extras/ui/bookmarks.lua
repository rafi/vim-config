-- Bookmarks with a global file store and sign annotations
local pack = require('rafi.pack')

-- Memoized, so the keys work even before the first FileType event.
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/tomasky/bookmarks.nvim' })
	require('bookmarks').setup({
		save_file = vim.fn.stdpath('state') .. '/bookmarks.json',
		keywords = {
			['@t'] = ' ',
			['@w'] = ' ',
			['@f'] = '⛏ ',
			['@n'] = ' ',
		},
	})
end

pack.on_event('FileType', function()
	-- Setup only attaches the current buffer, so also refresh the buffer
	-- that fired the event, in case it isn't the current one.
	local buf = tonumber(vim.fn.expand('<abuf>'))
	load()
	vim.schedule(function()
		if buf and vim.api.nvim_buf_is_valid(buf) then
			require('bookmarks').refresh(buf)
		end
	end)
end)

require('rafi.util.mini').on_which_key(function()
	require('which-key').add({ { 'm', group = 'marks' } })
end)

local function map(lhs, fn, desc)
	vim.keymap.set('n', lhs, function()
		load()
		require('bookmarks')[fn]()
	end, { desc = desc })
end

-- stylua: ignore start
map('mm', 'bookmark_toggle', 'Toggle mark')
map('mi', 'bookmark_ann', 'Annotate mark')
map('m<BS>', 'bookmark_clean', 'Clean buffer marks')
map('m]', 'bookmark_next', 'Jump to next mark')
map('m[', 'bookmark_prev', 'Jump to previous mark')
map('m/', 'bookmark_list', 'List marks')
map('m<Space>', 'bookmark_clear_all', 'Remove all marks')
-- stylua: ignore end
