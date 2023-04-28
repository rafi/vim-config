return {

	{
		'glepnir/flybuf.nvim',
		cmd = 'FlyBuf',
		keys = {
			{ '<Leader><Tab>', function() require('flybuf').toggle() end, desc = 'Flybuf' }
		},
		config = true
	},

}
