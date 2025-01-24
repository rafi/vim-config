return {

	-- Fast Neovim http client written in Lua
	{
		'rest-nvim/rest.nvim',
		main = 'rest-nvim',
		ft = 'http',
		cmd = 'Rest',
		keys = {
			{ '<Leader>ch', '<cmd>Rest run<CR>', desc = 'Execute HTTP request' },
		},
		opts = { skip_ssl_verification = true },
	},
}
