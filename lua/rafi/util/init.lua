-- Util: Init
-- https://github.com/rafi/vim-config
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua

---@class rafi.util
---@field color rafi.util.color
---@field preview rafi.util.preview
---@field lualine rafi.util.lualine
local M = {}

---@type table<string, string|string[]>
local deprecated = {}

setmetatable(M, {
	__index = function(t, k)
		local dep = deprecated[k]
		if dep then
			local mod = type(dep) == 'table' and dep[1] or dep
			local key = type(dep) == 'table' and dep[2] or k
			M.deprecate(
				[[require("rafi.util").]] .. k,
				[[require("rafi.util").]] .. mod .. '.' .. key
			)
			t[mod] = require('rafi.util.' .. mod) -- load here to prevent loops
			return t[mod][key]
		end
		t[k] = require('rafi.util.' .. k)
		return t[k]
	end,
})

-- Warn once that `old` was renamed to `new`.
function M.deprecate(old, new)
	vim.notify_once(
		('`%s` is deprecated. Please use `%s` instead'):format(old, new),
		vim.log.levels.WARN,
		{ title = 'Rafi' }
	)
end

-- Statuscolumn expression: snacks' statuscolumn once snacks is loaded, else
-- empty, so windows drawn before snacks (or with it disabled) don't error.
---@return string
function M.statuscolumn()
	return package.loaded.snacks and require('snacks.statuscolumn').get() or ''
end

return M
