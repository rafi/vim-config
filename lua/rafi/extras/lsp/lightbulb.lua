return {

	-- VSCode 💡 for neovim's built-in LSP
	{
		'kosayoda/nvim-lightbulb',
		event = { 'BufReadPre', 'BufNewFile' },
		opts = {
			ignore = {
				clients = { 'null-ls' },
			},
		},
		config = function(_, opts)
			require('nvim-lightbulb').setup(opts)
			vim.api.nvim_create_autocmd('CursorHold', {
				group = vim.api.nvim_create_augroup('rafi.lightbulb', {}),
				callback = function()
					require('nvim-lightbulb').update_lightbulb()
				end,
			})
		end,
	},
}
