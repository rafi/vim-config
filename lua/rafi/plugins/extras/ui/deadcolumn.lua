return {

	-- Show colorcolumn dynamically
	{
		'Bekaboo/deadcolumn.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		opts = {
			scope = 'visible',
		},
	},
}
