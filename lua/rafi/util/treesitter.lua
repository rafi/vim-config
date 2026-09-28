-- Tree-sitter helpers for the treesitter.nvim-treesitter extra
-- https://github.com/rafi/vim-config
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/treesitter.lua

local M = {}

---@type table<string, boolean>?
M._installed = nil
---@type table<string, boolean>
M._queries = {}

---Languages whose parser nvim-treesitter has installed. Cached. Pass
---`update` to re-read the install directory (after an install).
---@param update boolean?
---@return table<string, boolean>
function M.get_installed(update)
	if update then
		M._installed, M._queries = {}, {}
		local installed = require('nvim-treesitter').get_installed('parsers')
		for _, lang in ipairs(installed) do
			M._installed[lang] = true
		end
	end
	return M._installed or {}
end

---@param lang string
---@param query string
---@return boolean
function M.have_query(lang, query)
	local key = lang .. ':' .. query
	if M._queries[key] == nil then
		M._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
	end
	return M._queries[key]
end

---Whether a filetype (or buffer, default current) has an installed parser,
---and optionally a query of the given kind (e.g. 'highlights', 'folds').
---@param what string|integer|nil
---@param query? string
---@return boolean
function M.have(what, query)
	what = what or vim.api.nvim_get_current_buf()
	if type(what) == 'number' then
		what = vim.bo[what].filetype
	end
	---@cast what string
	local lang = vim.treesitter.language.get_lang(what)
	if lang == nil or M.get_installed()[lang] == nil then
		return false
	end
	return not query or M.have_query(lang, query)
end

function M.foldexpr()
	return M.have(nil, 'folds') and vim.treesitter.foldexpr() or '0'
end

function M.indentexpr()
	return M.have(nil, 'indents') and require('nvim-treesitter').indentexpr()
		or -1
end

-- Values set_default() applied, so re-applying them is always allowed.
---@type table<string, boolean>
local defaults = {}

---Set a buffer/window-local option, unless something other than Neovim's
---runtime files (a user ftplugin, a plugin, a modeline) already changed it
---away from the global value. Returns whether the option was set.
---@param option string
---@param value any
---@return boolean
function M.set_default(option, value)
	local l = vim.api.nvim_get_option_value(option, { scope = 'local' })
	local g = vim.api.nvim_get_option_value(option, { scope = 'global' })
	defaults[('%s=%s'):format(option, value)] = true
	if l ~= g and not defaults[('%s=%s'):format(option, l)] then
		local info = vim.api.nvim_get_option_info2(option, { scope = 'local' })
		-- Negative ids (Lua, modeline, command line) aren't scripts, and
		-- getscriptinfo() rejects them.
		local sid = info.last_set_sid
		local script = sid > 0 and vim.fn.getscriptinfo({ sid = sid })[1]
		local runtime = vim.fn.expand('$VIMRUNTIME')
		if not (script and vim.startswith(script.name, runtime)) then
			return false
		end
	end
	vim.api.nvim_set_option_value(option, value, { scope = 'local' })
	return true
end

---Checks the tools nvim-treesitter main needs to build parsers.
---@return boolean ok, table<string, boolean> health
function M.check()
	local function have(tool)
		return vim.fn.executable(tool) == 1
	end
	local health = {
		['tree-sitter (CLI)'] = have('tree-sitter'),
		['C compiler'] = vim.env.CC ~= nil or have('cc'),
		tar = have('tar'),
		curl = have('curl'),
	}
	local ok = true
	for _, v in pairs(health) do
		ok = ok and v
	end
	return ok, health
end

---Installs tree-sitter-cli with mason when it's missing.
---@param cb fun(ok: boolean, err?: string)
function M.ensure_treesitter_cli(cb)
	if vim.fn.executable('tree-sitter') == 1 then
		return cb(true)
	end
	if not pcall(require, 'mason') then
		return cb(false, '`mason.nvim` is not loaded, cannot install it.')
	end
	-- mason.setup() may have just put an installed CLI on $PATH.
	if vim.fn.executable('tree-sitter') == 1 then
		return cb(true)
	end
	local registry = require('mason-registry')
	registry.refresh(function()
		local p = registry.get_package('tree-sitter-cli')
		if p:is_installed() then
			return cb(true)
		end
		vim.notify('Installing `tree-sitter-cli` with mason…')
		p:install(
			nil,
			vim.schedule_wrap(function(success)
				if success then
					cb(true)
				else
					cb(false, 'Failed to install `tree-sitter-cli` with mason.')
				end
			end)
		)
	end)
end

---Runs `cb` (a parser install/update) once the build tools are present.
---Otherwise reports which ones are missing.
---@param cb fun()
function M.build(cb)
	M.ensure_treesitter_cli(function(_, err)
		local ok, health = M.check()
		if ok then
			return cb()
		end
		local lines = { 'Unmet requirements for **nvim-treesitter** `main`:' }
		local keys = vim.tbl_keys(health)
		table.sort(keys)
		for _, k in ipairs(keys) do
			lines[#lines + 1] = ('- %s `%s`'):format(health[k] and '✅' or '❌', k)
		end
		vim.list_extend(lines, {
			'',
			'Run `:checkhealth nvim-treesitter` for more information.',
		})
		vim.list_extend(lines, err and { '', err } or {})
		vim.notify(table.concat(lines, '\n'), vim.log.levels.ERROR)
	end)
end

return M
