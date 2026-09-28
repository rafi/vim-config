-- Util: Icons (misc, ft, diagnostics, git, status, LSP kinds)
-- https://github.com/rafi/vim-config
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua

---@class rafi.util.icons
local M = {}

-- stylua: ignore
M.misc = {
	dots = '󰇘',
	git  = ' ',
}

-- stylua: ignore
M.ft = {
	gh              = ' ',
	['markdown.gh'] = ' ',
	octo            = ' ',
}

-- stylua: ignore
M.diagnostics = {
	Error = ' ',
	Hint  = ' ',
	Info  = ' ',
	Warn  = ' ',
}

-- stylua: ignore
M.git = {
	added    = ' ',
	modified = ' ',
	removed  = ' ',
}

-- Compact variants used by the statusline.
-- stylua: ignore
M.status = {
	diagnostics = {
		error = ' ',
		hint  = ' ',
		info  = ' ',
		warn  = ' ',
	},
	filename = {
		modified = '+',
		readonly = '🔒',
		zoomed   = '🔎',
	},
	git = {
		added    = '₊',
		modified = '∗',
		removed  = '₋',
	},
}

-- stylua: ignore
M.kinds = {
	Array         = ' ',
	Boolean       = '󰨙 ',
	Class         = ' ',
	Codeium       = '󰘦 ',
	Color         = ' ',
	Control       = ' ',
	Collapsed     = ' ',
	Constant      = '󰏿 ',
	Constructor   = ' ',
	Copilot       = ' ',
	Enum          = ' ',
	EnumMember    = ' ',
	Event         = ' ',
	Field         = ' ',
	File          = ' ',
	Folder        = ' ',
	Function      = '󰊕 ',
	Interface     = ' ',
	Key           = ' ',
	Keyword       = ' ',
	Method        = '󰊕 ',
	Module        = ' ',
	Namespace     = '󰦮 ',
	Null          = ' ',
	Number        = '󰎠 ',
	Object        = ' ',
	Operator      = ' ',
	Package       = ' ',
	Property      = ' ',
	Reference     = ' ',
	Snippet       = '󱄽 ',
	String        = ' ',
	Struct        = '󰆼 ',
	Supermaven    = ' ',
	TabNine       = '󰏚 ',
	Text          = ' ',
	TypeParameter = ' ',
	Unit          = ' ',
	Value         = ' ',
	Variable      = '󰀫 ',
}

---@type table<string, string[]|boolean>?
M.kind_filter = {
	default = {
		'Class',
		'Constructor',
		'Enum',
		'Field',
		'Function',
		'Interface',
		'Method',
		'Module',
		'Namespace',
		'Package',
		'Property',
		'Struct',
		'Trait',
	},
	markdown = false,
	help = false,
	-- Each filetype can have its own filter
	lua = {
		'Class',
		'Constructor',
		'Enum',
		'Field',
		'Function',
		'Interface',
		'Method',
		'Module',
		'Namespace',
		-- 'Package', -- remove package since luals uses it for control flow structures
		'Property',
		'Struct',
		'Trait',
	},
}

---@param buf? number
---@return string[]?
function M.get_kind_filter(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local ft = vim.bo[buf].filetype
	if M.kind_filter == false then
		return
	end
	if M.kind_filter[ft] == false then
		return
	end
	if type(M.kind_filter[ft]) == 'table' then
		return M.kind_filter[ft]
	end
	---@diagnostic disable-next-line: return-type-mismatch
	return type(M.kind_filter) == 'table'
			and type(M.kind_filter.default) == 'table'
			and M.kind_filter.default
		or nil
end

return M
