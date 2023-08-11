-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/elixir.lua

return {

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				table.insert(opts.ensure_installed, 'yaml')
			end
		end,
	},

	{
		'neovim/nvim-lspconfig',
		dependencies = { 'b0o/SchemaStore.nvim', version = false },
		opts = {
			servers = {
				yamlls = {
					settings = {
						redhat = { telemetry = { enabled = false } },
						yaml = {
							completion = true,
							hover = true,
							validate = true,
							format = {
								enable = true,
							},
							schemas = {
								kubernetes = { 'k8s**.yaml', 'kube*/*.yaml' },
							},
						},
					},
					on_new_config = function(new_config)
						-- Lazy-load schemastore when needed
						new_config.settings.yaml.schemaStore.enable = false
						new_config.settings.yaml.schemas = vim.tbl_extend(
							'force',
							require('schemastore').yaml.schemas(),
							new_config.settings.yaml.schemas or {}
						)
					end,
				},
			},
		},
	},
}
