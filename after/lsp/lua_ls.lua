-- Lua language server
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
---@type vim.lsp.Config
return {
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
			},
			codeLens = {
				enable = true,
			},
			completion = {
				callSnippet = 'Replace',
			},
			doc = {
				privateName = { '^_' },
			},
			hint = {
				enable = true,
				setType = false,
				paramType = true,
				paramName = 'Disable',
				semicolon = 'Disable',
				arrayIndex = 'Disable',
			},
		},
	},
}
