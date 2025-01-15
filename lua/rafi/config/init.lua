-- Rafi's Neovim config loader
-- https://github.com/rafi/vim-config

-- This uses LazyVim's config module.
-- See $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/config/init.lua

local M = {}

---@type table<string, string>
M.deprecated_extras = {
	['rafi.plugins.extras.editor.telescope'] = '`telescope.nvim` is now the default **RafiVim** picker.',
	['rafi.plugins.extras.ui.indent-blankline'] = "Use LazyVim's `indent-blankline.nvim` instead.",
}

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
	_load('rafi.config.' .. name)
	if name == 'options' then
		-- User's lua/config/options.lua is already loaded by lazyvim init.
		return
	end

	local pattern = 'LazyVim' .. name:sub(1, 1):upper() .. name:sub(2)
	vim.api.nvim_exec_autocmds(
		'User',
		{ pattern = pattern .. 'Defaults', modeline = false }
	)
	_load('config.' .. name)
	if vim.bo.filetype == 'lazy' then
		vim.cmd([[do VimResized]])
	end
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

-- Loaded by autocmd set in lua/rafi/config/lazy.lua
function M.setup()
	-- Overload LazyVim's config loader with rafi's loader.
	local loader = require('rafi.config').load
	LazyVim.config.load = loader

	-- Overload deprecated extras.
	local extras = require('lazyvim.util.plugin').deprecated_extras
	for k, v in pairs(M.deprecated_extras) do
		extras[k] = v
	end

	-- Load lua/rafi/config/options.lua
	loader('options')

	-- Check if extra is enabled, regardless of first namespace.
	---@param extra string
	LazyVim.has_extra = function(extra)
		local modname = '.extras.' .. extra
		if tbl_endswith(require('lazy.core.config').spec.modules, modname) then
			return true
		end
		return tbl_endswith(require('lazyvim.config').json.data.extras, modname)
	end

	-- Use Telescope by default.
	LazyVim.pick.want = function()
		vim.g.lazyvim_picker = vim.g.lazyvim_picker or 'auto'
		if vim.g.lazyvim_picker == 'auto' then
			return LazyVim.has_extra('editor.fzf') and 'fzf' or 'telescope'
		end
		return vim.g.lazyvim_picker
	end

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
