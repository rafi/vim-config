-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/formatting/prettier.lua

return {

	{
		'williamboman/mason.nvim',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				table.insert(opts.ensure_installed, 'prettierd')
			end
		end,
	},

	{
		'mhartington/formatter.nvim',
		optional = true,
		opts = function(_, opts)
			opts = opts or {}
			local filetypes = {
				-- FIXME:add more filetypes
				json = { require('formatter.defaults.prettierd') },
			}
			opts.filetype = vim.tbl_extend('keep', opts.filetype or {}, filetypes)
		end,
	},

	{
		'jose-elias-alvarez/null-ls.nvim',
		optional = true,
		opts = function(_, opts)
			local nls = require('null-ls')
			table.insert(opts.sources, nls.builtins.formatting.prettierd)
		end,
	},
}
