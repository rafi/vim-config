-- Util: language registry, filled by lua/rafi/extras/lang/<lang>.lua files
-- https://github.com/rafi/vim-config
--
-- Language files register their servers, tools, linters and formatters at
-- startup. plugin/{conform,lint,lspconfig,mason}.lua read them when their
-- plugins load (always later).

---@class rafi.lang.Spec
---@field servers? table<string, boolean> Enabled/disabled LSP servers
---@field keys? table<string, rafi.lsp.Keys[]> LSP keymaps per server
---@field tools? string[] Mason packages, besides LSP servers
---@field linters_by_ft? table<string, string[]> nvim-lint linters
---@field formatters_by_ft? table<string, conform.FiletypeFormatter>
---@field parsers? table<string, {url: string, location?: string}> Tree-sitter parsers missing from arborist's or nvim-treesitter's registry

local M = {
	---@type table<string, boolean>
	servers = {},
	---@type table<string, rafi.lsp.Keys[]>
	keys = {},
	---@type string[]
	tools = {},
	---@type table<string, string[]>
	linters_by_ft = {},
	---@type table<string, conform.FiletypeFormatter>
	formatters_by_ft = {},
	---@type table<string, {url: string, location?: string}>
	parsers = {},
}

---@param spec rafi.lang.Spec
function M.add(spec)
	M.servers = vim.tbl_extend('force', M.servers, spec.servers or {})
	for server, keys in pairs(spec.keys or {}) do
		M.keys[server] = vim.list_extend(M.keys[server] or {}, keys)
	end
	for _, tool in ipairs(spec.tools or {}) do
		if not vim.tbl_contains(M.tools, tool) then
			M.tools[#M.tools + 1] = tool
		end
	end
	for ft, linters in pairs(spec.linters_by_ft or {}) do
		M.linters_by_ft[ft] = linters
	end
	for ft, formatters in pairs(spec.formatters_by_ft or {}) do
		M.formatters_by_ft[ft] = formatters
	end
	M.parsers = vim.tbl_extend('force', M.parsers, spec.parsers or {})
end

return M
