-- JSON language server, with SchemaStore.nvim schemas
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/json.lua
---@type vim.lsp.Config
return {
	-- lazy-load schemastore when needed
	before_init = function(_, new_config)
		new_config.settings.json.schemas = new_config.settings.json.schemas or {}
		vim.list_extend(
			new_config.settings.json.schemas,
			require('schemastore').json.schemas()
		)
	end,
	settings = {
		json = {
			format = {
				enable = true,
			},
			validate = { enable = true },
		},
	},
}
