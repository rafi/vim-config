return {

	-- Super powerful color picker/colorizer plugin
	{
		'uga-rosa/ccc.nvim',
		event = 'FileType',
		keys = {
			{ '<Leader>mc', '<cmd>CccPick<CR>', desc = 'Color-picker' },
		},
		opts = {
			highlighter = {
				auto_enable = true,
				lsp = true,
				filetypes = {
					'html',
					'lua',
					'css',
					'scss',
					'sass',
					'less',
					'stylus',
					'javascript',
					'tmux',
					'typescript',
				},
				excludes = { 'lazy', 'mason', 'help', 'neo-tree' },
			},
		},
	},
}
