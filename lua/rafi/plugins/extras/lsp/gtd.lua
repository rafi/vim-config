return {

	{
		'hrsh7th/nvim-gtd',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = 'neovim/nvim-lspconfig',
		keys = {
			{
				'gf',
				function() require('gtd').exec({ command = 'split' }) end,
				desc = 'Go to definition or file',
			},
		},
		---@type gtd.kit.App.Config.Schema
		opts = {
			sources = {
				{ name = 'findup' },
				{
					name = 'walk',
					root_markers = {
						'.git', '.neoconf.json',
						'Makefile', 'tsconfig.json', 'package.json'
					},
					ignore_patterns = { '/node_modules', '/.git' },
				},
				{ name = 'lsp' },
			},
		},
	},

}
