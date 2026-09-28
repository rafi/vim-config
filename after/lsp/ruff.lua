-- Ruff Python linter and formatter language server
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/python.lua
---@type vim.lsp.Config
return {
	cmd_env = { RUFF_TRACE = 'messages' },
	init_options = {
		settings = {
			logLevel = 'error',
		},
	},
	on_attach = function(client)
		-- Disable hover in favor of Pyright
		client.server_capabilities.hoverProvider = false
	end,
}
