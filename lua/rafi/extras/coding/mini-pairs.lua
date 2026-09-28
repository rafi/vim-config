-- Auto pairs
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/coding.lua
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/nvim-mini/mini.pairs' })
	require('rafi.util.mini').pairs({
		modes = { insert = true, command = true, terminal = false },
		-- skip autopair when next character is one of these
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		-- skip autopair when the cursor is inside these treesitter nodes
		skip_ts = { 'string' },
		-- skip autopair when next character is a closing pair and there are
		-- more closing pairs than opening ones
		skip_unbalanced = true,
		-- better deal with markdown code blocks
		markdown = true,
	})
end)
