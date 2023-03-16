-- Rafi's config loader
-- https://github.com/rafi/vim-config

-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua

---@type RafiConfig
local M = {}

---@class RafiConfig
local defaults = {
	-- Load the default settings
	defaults = {
		autocmds = true, -- rafi.config.autocmds
		keymaps = true, -- rafi.config.keymaps
		options = true, -- rafi.config.options
	},
	-- String like `habamax` or a function that will load the colorscheme.
	---@type string|fun()
	colorscheme = '',

	icons = {
		diagnostics = {
			Error = '✘', --   ✘
			Warn = '', --   ⚠ 
			Hint = '', --  
			Info = 'ⁱ', --   ⁱ
		},
		-- Default completion kind symbols.
		kinds = {
			Text = '', --   𝓐
			Method = '', --  ƒ
			Function = '', -- 
			Constructor = '', --   
			Field = '', --  ﴲ ﰠ   
			Variable = '', --   
			Class = '', --  ﴯ 𝓒
			Interface = '', -- ﰮ    
			Module = '', --   
			Property = '襁', -- ﰠ 襁
			Unit = '', --  塞
			Value = '',
			Enum = '練', -- 練 ℰ 
			Keyword = '', --   🔐
			Snippet = '⮡', -- ﬌  ⮡ 
			Color = '',
			File = '', --  
			Reference = '', --  
			Folder = '', --  
			EnumMember = '',
			Constant = '', --  
			Struct = '', --   𝓢 פּ
			Event = '', --  🗲
			Operator = '', --   +
			TypeParameter = '', --  𝙏
		},
	},
}

M.did_init = false
function M.init()
	if not M.did_init then
		M.did_init = true
		-- load options here, before lazy init while sourcing plugin modules
		-- this is needed to make sure options will be correctly applied
		-- after installing missing plugins
		require('rafi.config').load('options')
	end
end

---@type RafiConfig
local options

---@param user_opts table|nil
function M.setup(user_opts)
	options = vim.tbl_deep_extend('force', defaults, user_opts or {})

	M.vim_require('.vault.vim')
	M.load('keymaps')
	M.load('autocmds')

	require('lazy.core.util').try(function()
		if type(M.colorscheme) == 'function' then
			M.colorscheme()
		elseif #M.colorscheme > 0 then
			vim.cmd.colorscheme(M.colorscheme)
		end
	end, {
		msg = 'Could not load your colorscheme',
		on_error = function(msg)
			require('lazy.core.util').error(msg)
			vim.cmd.colorscheme('habamax')
		end,
	})
end

---@param on_attach fun(client:lsp.Client, buffer:integer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd('LspAttach', {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

---@param plugin string
function M.has(plugin)
	return require('lazy.core.config').plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd('User', {
		pattern = 'VeryLazy',
		callback = function()
			fn()
		end,
	})
end

---@param name string
function M.plugin_opts(name)
	local plugin = require('lazy.core.config').plugins[name]
	if not plugin then
		return {}
	end
	local Plugin = require('lazy.core.plugin')
	return Plugin.values(plugin, 'opts', false)
end

-- Source vim script file, if exists.
---@param relpath string
function M.vim_require(relpath)
	local abspath = M.path_join(vim.fn.stdpath('config'), relpath)
	if vim.loop.fs_stat(abspath) then
		vim.fn.execute('source ' .. abspath)
	end
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
	local Util = require('lazy.core.util')
	local function _load(mod)
		Util.try(function()
			require(mod)
		end, {
			msg = 'Failed loading ' .. mod,
			on_error = function(msg)
				local modpath = require('lazy.core.cache').find(mod)
				if modpath then
					Util.error(msg)
				end
			end,
		})
	end
	-- always load rafi's file, then user file
	if M.defaults[name] then
		_load('rafi.config.' .. name)
	end
	_load('config.' .. name)
	if vim.bo.filetype == 'lazy' then
		-- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
		vim.cmd([[do VimResized]])
	end
end

-- Ensure package manager (lazy.nvim) exists.
function M.ensure_lazy()
	local lazypath = M.path_join(vim.fn.stdpath('data'), 'lazy', 'lazy.nvim')
	if not vim.loop.fs_stat(lazypath) then
		print('Installing lazy.nvim…')
		vim.fn.system({
			'git',
			'clone',
			'--filter=blob:none',
			'--branch=stable',
			'https://github.com/folke/lazy.nvim.git',
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
end

-- Validate if lua/plugins/ or lua/plugins.lua exist.
function M.has_user_plugins()
	local user_path = M.path_join(vim.fn.stdpath('config'), 'lua')
	return vim.loop.fs_stat(M.path_join(user_path, 'plugins'))
		or vim.loop.fs_stat(M.path_join(user_path, 'plugins.lua'))
end

-- Join paths.
M.path_join = function(...)
	return table.concat({ ... }, M.path_sep)
end

-- Variable holds OS directory separator.
M.path_sep = (function()
	if jit then
		local os = string.lower(jit.os)
		if os ~= 'windows' then
			return '/'
		else
			return '\\'
		end
	else
		return package.config:sub(1, 1)
	end
end)()

setmetatable(M, {
	__index = function(_, key)
		if options == nil then
			return vim.deepcopy(defaults)[key]
		end
		---@cast options RafiConfig
		return options[key]
	end,
})

return M
