-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/docker.lua

return {
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'dockerfile' })
			end
		end,
	},

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				dockerls = {},
				-- docker_compose_language_service = {},
			},
		},
	},

	{
		'mason.nvim',
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { 'hadolint' })
		end,
	},

	{
		'jose-elias-alvarez/null-ls.nvim',
		optional = true,
		opts = function(_, opts)
			local nls = require('null-ls')
			opts.sources = opts.sources or {}
			vim.list_extend(opts.sources, {
				nls.builtins.diagnostics.hadolint,
			})
		end,
		dependencies = {
			'mason.nvim',
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				vim.list_extend(opts.ensure_installed, { 'hadolint' })
			end,
		},
	},
}
