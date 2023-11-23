return {
	-- Not needed anymore with nvim-0.10.0
	{
		'lvimuser/lsp-inlayhints.nvim',
		branch = 'anticonceal',
		event = 'LspAttach',
		opts = {},
		config = function(_, opts)
			require('lsp-inlayhints').setup(opts)
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('LspAttach_inlayhints', {}),
				callback = function(args)
					if not (args.data and args.data.client_id) then
						return
					end
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					require('lsp-inlayhints').on_attach(client, args.buf)
				end,
			})
		end,
	},
}
