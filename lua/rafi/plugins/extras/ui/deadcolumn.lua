return {
	{
		'Bekaboo/deadcolumn.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		opts = {
			scope = 'visible',
		},
	},
}
