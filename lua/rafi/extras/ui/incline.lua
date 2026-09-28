return {

	-- Floating statuslines
	{
		'b0o/incline.nvim',
		event = 'FileType',
		opts = {
			ignore = {
				filetypes = { 'gitcommit' },
			},
		},
	},
}
