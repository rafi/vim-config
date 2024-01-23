return {

	-- Align text interactively
	{
		'echasnovski/mini.align',
		opts = {
			mappings = {
				start = 'gb',
				start_with_preview = 'gB',
			},
		},
		keys = {
			{ 'gb', mode = { 'n', 'x' } },
			{ 'gB', mode = { 'n', 'x' } },
		},
	},
}
