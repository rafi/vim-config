return {

	-- Create log statements on the fly
	{
		'chrisgrieser/nvim-chainsaw',
		opts = {},
		-- stylua: ignore
		keys = {
			{ '<Leader>dv', function() require('chainsaw').variableLog() end },
			{ '<Leader>dm', function() require('chainsaw').messageLog() end },
		},
	},
}
