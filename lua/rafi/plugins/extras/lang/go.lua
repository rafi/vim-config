-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/go.lua

return {

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, {
					'go',
					'gomod',
					'gosum',
					'gowork',
				})
			end
		end,
	},

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				gopls = {
					settings = {
						-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
						gopls = {
							gofumpt = true,
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
							semanticTokens = true,
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
							-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
								-- fillreturns = true,
								-- nonewvars = true,
								-- shadow = true,
								-- undeclaredname = true,
								-- unusedvariable = true,
								-- ST1000 = false,
								-- ST1005 = false,
							},
						},
					},
				},
			},
			setup = {
				gopls = function(_, _)
					-- workaround for gopls not supporting semanticTokensProvider
					-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
					require('rafi.lib.utils').on_attach(function(client, _)
						if client.name == 'gopls' then
							if not client.server_capabilities.semanticTokensProvider then
								local semantic =
									client.config.capabilities.textDocument.semanticTokens
								if semantic ~= nil then
									client.server_capabilities.semanticTokensProvider = {
										full = true,
										legend = {
											tokenTypes = semantic.tokenTypes,
											tokenModifiers = semantic.tokenModifiers,
										},
										range = true,
									}
								end
							end
						end
					end)
					-- end workaround
				end,
			},
		},
	},

	{
		'jose-elias-alvarez/null-ls.nvim',
		optional = true,
		opts = function(_, opts)
			local nls = require('null-ls')
			local sources = {
				nls.builtins.code_actions.gomodifytags,
				nls.builtins.code_actions.impl,
				nls.builtins.formatting.gofumpt,
				-- nls.builtins.formatting.goimports_reviser,
			}
			opts.sources = opts.sources or {}
			for _, source in ipairs(sources) do
				table.insert(opts.sources, source)
			end
		end,
	},

	{
		'mfussenegger/nvim-dap',
		optional = true,
		dependencies = {
			{
				'mason.nvim',
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					table.insert(opts.ensure_installed, 'delve')
				end,
			},
		},
	},

	{
		'nvim-neotest/neotest',
		optional = true,
		dependencies = {
			'nvim-neotest/neotest-go',
			optional = true,
		},
		opts = {
			adapters = {
				['neotest-go'] = {
					-- Here we can set options for neotest-go, e.g.
					-- args = { '-tags=integration' }
				},
			},
		},
	},
}
