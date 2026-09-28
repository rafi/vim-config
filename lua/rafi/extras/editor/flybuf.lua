return {

	-- List buffers in a float window
	{
		'glepnir/flybuf.nvim',
		cmd = 'FlyBuf',
		keys = {
			-- stylua: ignore
			{ 'sf', function() require('flybuf').toggle() end, desc = 'Flybuf' },
		},
		opts = {},
	},
}
