-- rafi.plugins.extras.lang.helm
--

return {

	{ 'towolf/vim-helm', ft = 'helm' },

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'yaml' })
			end
		end,
	},

	{
		'mason.nvim',
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { 'helm-ls' })
		end,
	},
}
