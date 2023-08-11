return {
	{
		'williamboman/mason.nvim',
		opts = function(_, opts)
			table.insert(opts.ensure_installed, 'write-good')
		end,
	},
	{
		'jose-elias-alvarez/null-ls.nvim',
		optional = true,
		opts = function(_, opts)
			local nls = require('null-ls')
			local source = nls.builtins.diagnostics.write_good.with({
				diagnostics_postprocess = function(diagnostic)
					diagnostic.severity = vim.diagnostic.severity.HINT
				end,
			})

			table.insert(opts.sources, source)
		end,
	},
}
