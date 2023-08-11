return {

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				ruff_lsp = {},
			},
			setup = {
				ruff_lsp = function(_, opts)
					local root_files = {
						'.python-version',
						'pyproject.toml',
						'ruff.toml',
					}
					local util = require('lspconfig.util')
					opts.root_dir = util.root_pattern(unpack(root_files))
						or util.find_git_ancestor()

					require('rafi.lib.utils').on_attach(function(client, _)
						if client.name == 'ruff_lsp' then
							client.server_capabilities.hoverProvider = false
						end
					end)
				end,
			},
		},
	},

	{
		'williamboman/mason.nvim',
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				'ruff',
				'ruff-lsp',
			})
		end,
	},

	{
		'jose-elias-alvarez/null-ls.nvim',
		optional = true,
		opts = function(_, opts)
			if type(opts.sources) == 'table' then
				local nls = require('null-ls')
				table.insert(opts.sources, nls.builtins.formatting.ruff)
			end
		end,
	},
}
