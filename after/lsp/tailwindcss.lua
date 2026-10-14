-- Tailwind CSS language server
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/tailwind.lua

-- Filetypes to leave out of nvim-lspconfig's default list.
local exclude = { 'markdown' }
-- Filetypes to add to the default list.
local include = {}

-- Returns nvim-lspconfig's default filetypes. `filetypes` is a list, so this
-- file would replace it entirely instead of extending it.
---@return string[]
local function default_filetypes()
	for _, file in
		ipairs(vim.api.nvim_get_runtime_file('lsp/tailwindcss.lua', true))
	do
		if not file:find('/after/lsp/', 1, true) then
			local ok, config = pcall(dofile, file)
			if ok and type(config) == 'table' and config.filetypes then
				return vim.deepcopy(config.filetypes)
			end
		end
	end
	return {}
end

local filetypes = vim.tbl_filter(function(ft)
	return not vim.tbl_contains(exclude, ft)
end, default_filetypes())
vim.list_extend(filetypes, include)

---@type vim.lsp.Config
return {
	filetypes = #filetypes > 0 and filetypes or nil,
	settings = {
		tailwindCSS = {
			includeLanguages = {
				elixir = 'html-eex',
				eelixir = 'html-eex',
				heex = 'html-eex',
			},
		},
	},
}
