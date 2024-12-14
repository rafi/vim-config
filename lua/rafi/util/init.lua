-- Util: Init
-- https://github.com/rafi/vim-config

-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua

local LazyUtil = require('lazy.core.util')

---@class rafi.util: LazyUtilCore
---@field color rafi.util.color
---@field cmp rafi.util.cmp
---@field contextmenu rafi.util.contextmenu
---@field edit rafi.util.edit
---@field preview rafi.util.preview
---@field lualine rafi.util.lualine
local M = {}

---@type table<string, string|string[]>
local deprecated = {}

setmetatable(M, {
	__index = function(t, k)
		if LazyUtil[k] then
			return LazyUtil[k]
		end
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

function M.deprecate(old, new)
	M.warn(('`%s` is deprecated. Please use `%s` instead'):format(old, new), {
		title = 'Rafi',
		once = true,
		stacktrace = true,
		stacklevel = 6,
	})
end

return M
