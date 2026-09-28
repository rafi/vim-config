-- YAML language server, with SchemaStore.nvim and Kubernetes schemas
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/yaml.lua
---@type vim.lsp.Config
return {
	-- Have to add this for yamlls to understand that we support line folding
	capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			},
		},
	},
	-- lazy-load schemastore when needed
	before_init = function(_, new_config)
		new_config.settings.yaml.schemas = vim.tbl_deep_extend(
			'force',
			new_config.settings.yaml.schemas or {},
			require('schemastore').yaml.schemas()
		)
	end,
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			completion = true,
			hover = true,
			keyOrdering = false,
			format = {
				enable = true,
			},
			validate = true,
			schemaStore = {
				-- Must disable built-in schemaStore support to use
				-- schemas from SchemaStore.nvim plugin
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = '',
			},
			schemas = {
				kubernetes = { 'k8s**.yaml', 'kube*/*.yaml' },
			},
		},
	},
}
