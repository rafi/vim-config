-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/terraform.lua

return {

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, {
					'terraform',
					'hcl',
				})
			end
		end,
	},

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				terraformls = {},
			},
		},
	},

	{
		'jose-elias-alvarez/null-ls.nvim',
		optional = true,
		opts = function(_, opts)
			if type(opts.sources) == 'table' then
				local builtins = require('null-ls.builtins')
				table.insert(opts.sources, builtins.formatting.terraform_fmt)
				table.insert(opts.sources, builtins.diagnostics.terraform_validate)
			end
		end,
	},
}
