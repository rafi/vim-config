-- Go language server
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/go.lua
---@type vim.lsp.Config
return {
	init_options = {
		semanticTokens = true,
	},
	settings = {
		gopls = {
			gofumpt = true,
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			analyses = {
				ST1000 = false,
				fieldalignment = false,
				nilness = true,
				unusedparams = true,
				unusedvariable = true,
				unusedwrite = true,
				useany = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = {
				'-.git',
				'-.vscode',
				'-.idea',
				'-.vscode-test',
				'-node_modules',
			},
		},
	},
	-- workaround for gopls not supporting semanticTokensProvider
	-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
	on_attach = function(client)
		if
			client.config
			and client.config.init_options
			and client.config.init_options.semanticTokens
			and not client.server_capabilities.semanticTokensProvider
		then
			local semantic = client.config.capabilities.textDocument.semanticTokens
			client.server_capabilities.semanticTokensProvider = {
				full = true,
				legend = {
					tokenTypes = semantic.tokenTypes,
					tokenModifiers = semantic.tokenModifiers,
				},
				range = true,
			}
		end
	end,
}
