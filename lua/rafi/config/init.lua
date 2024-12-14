-- Rafi's Neovim config loader
-- https://github.com/rafi/vim-config

-- This uses LazyVim's config module.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua

local M = {}

local lazy_clipboard

-- Load rafi and user config files.
function M.setup()
	-- Autocmds can be loaded lazily when not opening a file
	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		M.load('autocmds')
	end

	local group = vim.api.nvim_create_augroup('RafiVim', { clear = true })
	vim.api.nvim_create_autocmd('User', {
		group = group,
		pattern = 'VeryLazy',
		callback = function()
			if lazy_autocmds then
				M.load('autocmds')
			end
			M.load('keymaps')
			if lazy_clipboard ~= nil then
				vim.opt.clipboard = lazy_clipboard
			end
		end,
	})
end

-- Load lua/rafi/config/* and user lua/config/* files.
---@param name 'autocmds' | 'options' | 'keymaps'
function M.load(name)
	local function _load(mod)
		if require('lazy.core.cache').find(mod)[1] then
			LazyVim.try(function()
				require(mod)
			end, { msg = 'Failed loading ' .. mod })
		end
	end
	-- Always load rafi's file, then user file
	_load('rafi.config.' .. name)
	_load('config.' .. name)
	if vim.bo.filetype == 'lazy' then
		vim.cmd([[do VimResized]])
	end
	local pattern = 'RafiVim' .. name:sub(1, 1):upper() .. name:sub(2)
	vim.api.nvim_exec_autocmds('User', { pattern = pattern, modeline = false })
end

-- Check if table has a value that ends with a suffix.
---@param tbl table
---@param suffix string
---@return boolean
local function tbl_endswith(tbl, suffix)
	local l = #suffix
	for _, v in ipairs(tbl) do
		if string.sub(v, -l) == suffix then
			return true
		end
	end
	return false
end

-- This is the main entry-point once lazy.nvim is set-up.
-- Called from `lua/rafi/plugins/init.lua`
M.did_init = false
function M.init()
	if M.did_init then
		return
	end
	M.did_init = true
	local plugin = require('lazy.core.config').spec.plugins.LazyVim
	if plugin then
		vim.opt.rtp:append(plugin.dir)
	end

	-- This is premature by purpose, to load the LazyVim global.
	local LazyVimConfig = require('lazyvim.config')

	-- Delay notifications till vim.notify was replaced or after 500ms
	LazyVim.lazy_notify()

	-- Load options here, before lazy init while sourcing plugin modules
	-- this is needed to make sure options will be correctly applied
	-- after installing missing plugins
	M.load('options')

	-- Defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
	lazy_clipboard = vim.opt.clipboard
	vim.opt.clipboard = ''

	---@param extra string
	LazyVim.has_extra = function(extra)
		local modname = '.extras.' .. extra
		if tbl_endswith(require('lazy.core.config').spec.modules, modname) then
			return true
		end
		return tbl_endswith(require('lazyvim.config').json.data.extras, modname)
	end
	LazyVim.pick.want = function()
		vim.g.lazyvim_picker = vim.g.lazyvim_picker or 'auto'
		if vim.g.lazyvim_picker == 'auto' then
			return LazyVim.has_extra('editor.fzf') and 'fzf' or 'telescope'
		end
		return vim.g.lazyvim_picker
	end
	LazyVim.cmp_engine = function()
		vim.g.lazyvim_cmp = vim.g.lazyvim_cmp or 'auto'
		if vim.g.lazyvim_cmp == 'auto' then
			return LazyVim.has_extra('coding.blink') and 'blink.cmp' or 'nvim-cmp'
		end
		return vim.g.lazyvim_cmp
	end
	LazyVim.plugin.setup()
	LazyVimConfig.json.load()

	-- Add lua/*/plugins/extras as list of "extra" sources
	LazyVim.extras.sources = {
		{
			name = 'LazyVim',
			desc = 'LazyVim extras',
			module = 'lazyvim.plugins.extras',
		},
		{
			name = 'Rafi ',
			desc = 'Rafi extras',
			module = 'rafi.plugins.extras',
		},
		{
			name = 'User ',
			desc = 'User extras',
			module = 'plugins.extras',
		},
	}
end

return M
