-- Active indent scope line and textobjects (mini.indentscope)
-- Replaces the snacks scope highlight and its `[i`, `]i`, `ii`, `ai` keys.
-- Indent guides stay with snacks.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ui/mini-indentscope.lua
local pack = require('rafi.pack')

-- Turn off snacks scope. Snacks reads its config after extras load, so
-- this is enough.
if Snacks and Snacks.config then
	Snacks.config.scope = Snacks.config.scope or {}
	Snacks.config.scope.enabled = false
	Snacks.config.indent = Snacks.config.indent or {}
	Snacks.config.indent.scope = Snacks.config.indent.scope or {}
	Snacks.config.indent.scope.enabled = false
end

-- No indent scope in special buffers.
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi.mini-indentscope', {}),
	pattern = {
		'Trouble',
		'alpha',
		'dashboard',
		'fzf',
		'help',
		'lazy',
		'mason',
		'ministarter',
		'neo-tree',
		'notify',
		'sidekick_terminal',
		'snacks_dashboard',
		'snacks_notif',
		'snacks_terminal',
		'snacks_win',
		'toggleterm',
		'trouble',
	},
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

vim.api.nvim_create_autocmd('User', {
	group = vim.api.nvim_create_augroup('rafi.mini-indentscope.snacks', {}),
	pattern = 'SnacksDashboardOpened',
	callback = function(data)
		vim.b[data.buf].miniindentscope_disable = true
	end,
})

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvim-mini/mini.indentscope' })
	require('mini.indentscope').setup({
		-- symbol = '▏',
		symbol = '│',
		options = { try_as_border = true },
	})
end

pack.on_event('BufReadPost,BufNewFile', load)
