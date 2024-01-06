-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/yaml.lua

return {

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'yaml' })
			end
		end,
	},

	{
		'b0o/SchemaStore.nvim',
		lazy = true,
		version = false, -- last release is way too old
	},

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				yamlls = {
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
					on_new_config = function(new_config)
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
							validate = true,
							format = {
								enable = true,
							},
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
				},
			},
			setup = {
				yamlls = function()
					-- Neovim < 0.10 does not have dynamic registration for formatting
					if vim.fn.has('nvim-0.10') == 0 then
						require('lazyvim.util').lsp.on_attach(function(client, _)
							if client.name == 'yamlls' then
								client.server_capabilities.documentFormattingProvider = true
							end
						end)
					end
				end,
			},
		},
	},
}
