-- Rafi's Neovim config loader
-- https://github.com/rafi/vim-config

-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua

---@type RafiConfig
local M = {}

M.lazy_version = '>=9.1.0'

---@class RafiConfig
local defaults = {
	-- Load the default settings
	defaults = {
		autocmds = true, -- rafi.config.autocmds
		keymaps = true,  -- rafi.config.keymaps
		-- rafi.config.options can't be configured here since it's loaded premature
		-- Disable loading options with following line at the top of your init.lua:
		-- `package.loaded['lazyvim.config.options'] = true`

		features = {
			elite_mode = false,
			window_q_mapping = true,
		},
	},
	-- String like `habamax` or a function that will load the colorscheme.
	---@type string|fun()
	colorscheme = '',

	icons = {
		diagnostics = {
			Error = '✘', --   ✘
			Warn = '',  --    ⚠ 
			Info = 'ⁱ',  --    ⁱ
			Hint = '',  --   
		},
		status = {
			git = {
				added = '₊',    --  ₊
				modified = '∗', --  ∗
				removed = '₋',  --  ₋
			},
			diagnostics = {
				error = ' ',
				warn = ' ',
				info = ' ',
				hint = ' '
			},
			filename = {
				modified = '+',
				readonly = '🔒',
				zoomed = '🔎',
			},
		},
		-- Default completion kind symbols.
		kinds = {
			Array = ' ',  --   󰅨 󱃶 
			Boolean = '◩ ',  --  ◩ 󰔡 󱃙 󰟡 󰨙
			Class = ' ', --   ﴯ 𝓒
			Color = ' ', --  
			Constant = ' ', --   
			Constructor = ' ', --     
			Copilot = ' ',  -- 
			Enum = '練 ', --  練 ℰ 
			EnumMember = ' ', --  
			Event = ' ', --  
			Field = ' ', --    ﴲ   
			File = ' ', --     
			Folder = ' ', --   
			Function = ' ', --   
			Interface = ' ', --  ﰮ    
			Key = ' ',  -- 
			Keyword = ' ', --    
			Method = ' ', --   ƒ
			Module = ' ', --     
			Namespace = ' ',  --   
			Null = ' ',  --  󰟢 ﳠ
			Number = ' ',  --   
			Object = ' ',  --   
			Operator = ' ', --    +
			Package = ' ',  --    
			Property = '襁 ', --  ﰠ  
			Reference = ' ', --   
			Snippet = ' ', --  ﬌  ⮡  
			String = '󰅳 ',  --  󰅳
			Struct = ' ', --   𝓢 פּ
			Text = ' ', --    𝓐
			TypeParameter = ' ', --   𝙏
			Unit = ' ', --   塞
			Value = ' ', --    
			Variable = ' ', --    
		},
	},
}

M.did_init = false
function M.init()
	if not M.did_init then
		M.did_init = true
		-- delay notifications till vim.notify was replaced or after 500ms
		require('rafi.config').lazy_notify()

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
	if not M.did_init then
		M.init()
	end
	options = vim.tbl_deep_extend('force', defaults, user_opts or {})
	if not M.has_version() then
		require('lazy.core.util').error(
			string.format(
				'**lazy.nvim** version %s is required.\n Please upgrade **lazy.nvim**',
				M.lazy_version
			)
		)
		error('Exiting')
	end

	-- Override config with user config at lua/config/setup.lua
	local user_setup_path = M.path_join(vim.fn.stdpath('config'), 'lua', 'config', 'setup.lua')
	if vim.loop.fs_stat(user_setup_path) ~= nil then
		options = require('config.setup').override(options)
	end
	for feat_name, feat_val in pairs(options.defaults.features) do
		vim.g['rafi_' .. feat_name] = feat_val
	end

	M.load('autocmds')
	M.load('keymaps')

	-- Set colorscheme
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

local augroup_lsp_attach = vim.api.nvim_create_augroup('rafi_lsp_attach', {})

---@param on_attach fun(client:lsp.Client, buffer:integer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd('LspAttach', {
		group = augroup_lsp_attach,
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

---@param range? string
function M.has_version(range)
	local Semver = require('lazy.manage.semver')
	return Semver.range(range or M.lazy_version)
		:matches(require('lazy.core.config').version or '0.0.0')
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

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
	local Util = require('lazy.core.util')
	local function _load(mod)
		Util.try(function()
			require(mod)
		end, {
			msg = 'Failed loading ' .. mod,
			on_error = function(msg)
				local info = require('lazy.core.cache').find(mod)
				if info == nil or (type(info) == 'table' and #info == 0) then
					return
				end
				Util.error(msg)
			end,
		})
	end
	-- always load rafi's file, then user file
	if M.defaults[name] or name == 'options' then
		_load('rafi.config.' .. name)
	end
	_load('config.' .. name)
	if vim.bo.filetype == 'lazy' then
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
	return vim.loop.fs_stat(M.path_join(user_path, 'plugins')) ~= nil
		or vim.loop.fs_stat(M.path_join(user_path, 'plugins.lua')) ~= nil
end

-- Delay notifications till vim.notify was replaced or after 500ms.
function M.lazy_notify()
	local notifs = {}
	local function temp(...) table.insert(notifs, vim.F.pack_len(...)) end

	local orig = vim.notify
	vim.notify = temp

	local timer = vim.loop.new_timer()
	local check = vim.loop.new_check()

	local replay = function()
		timer:stop()
		check:stop()
		if vim.notify == temp then
			vim.notify = orig -- put back the original notify if needed
		end
		vim.schedule(function()
			---@diagnostic disable-next-line: no-unknown
			for _, notif in ipairs(notifs) do
				vim.notify(vim.F.unpack_len(notif))
			end
		end)
	end

	-- wait till vim.notify has been replaced
	check:start(function()
		if vim.notify ~= temp then replay() end
	end)
	-- or if it took more than 500ms, then something went wrong
	timer:start(500, 0, replay)
end

-- Join paths.
---@private
M.path_join = function(...)
	return table.concat({ ... }, M.path_sep)
end

-- Variable holds OS directory separator.
---@private
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
