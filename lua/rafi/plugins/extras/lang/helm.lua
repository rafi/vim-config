-- rafi.plugins.extras.lang.helm
--

LazyVim.lsp.on_attach(function(client, buffer)
	if client.name == 'yamlls' then
		if
			vim.api.nvim_get_option_value('filetype', { buf = buffer }) == 'helm'
		then
			vim.schedule(function()
				vim.cmd('LspStop ++force yamlls')
			end)
		end
	end
end)

return {

	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'helm', 'yaml' })
			end

			vim.filetype.add({
				pattern = {
					['.*/templates/.*%.ya?ml'] = 'helm',
					['.*/templates/.*%.tpl'] = 'helm',
				},
			})
		end,
	},

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				yamlls = {},
				helm_ls = {},
			},
		},
	},

	{
		'mason.nvim',
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { 'helm-ls' })
		end,
	},
}
