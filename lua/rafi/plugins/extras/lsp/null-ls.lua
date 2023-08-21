return {

	{
		'jose-elias-alvarez/null-ls.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = { 'williamboman/mason.nvim' },
		opts = function(_, opts)
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
			local builtins = require('null-ls').builtins
			local sources = {
				builtins.formatting.stylua,
				builtins.formatting.shfmt,
			}
			for _, source in ipairs(sources) do
				table.insert(opts.sources, source)
			end

			opts.fallback_severity = vim.diagnostic.severity.INFO
			opts.should_attach = function(bufnr)
				return not vim.api.nvim_buf_get_name(bufnr):match('^[a-z]+://')
			end
			opts.root_dir = require('null-ls.utils').root_pattern(
				'.git',
				'_darcs',
				'.hg',
				'.bzr',
				'.svn',
				'.null-ls-root',
				'.neoconf.json',
				'.python-version',
				'Makefile'
			)
		end,
	},

	-- You can add your own sources. Here's an example:
	-- {
	-- 	'jose-elias-alvarez/null-ls.nvim',
	-- 	optional = true,
	-- 	opts = function(_, opts)
	-- 		local builtins = require('null-ls.builtins')
	-- 		local sources = {
	-- 			builtins.formatting.black,
	-- 			builtins.formatting.fixjson,
	-- 			builtins.formatting.golines,
	-- 			builtins.formatting.markdownlint,
	-- 			builtins.formatting.shellharden,
	-- 			builtins.formatting.sql_formatter,
	-- 			builtins.formatting.taplo,
	-- 			builtins.diagnostics.markdownlint,
	-- 			builtins.diagnostics.mypy,
	-- 			builtins.diagnostics.vint,
	-- 			builtins.diagnostics.yamllint,
	-- 			builtins.code_actions.shellcheck,
	-- 		}
	-- 		opts.sources = opts.sources or {}
	-- 		for _, source in ipairs(sources) do
	-- 			table.insert(opts.sources, source)
	-- 		end
	-- 	end,
	-- },
}
