return {

	-- Create log statements on the fly
	{
		'chrisgrieser/nvim-chainsaw',
		opts = {},
		-- stylua: ignore
		keys = {
			{ 'g?v', function() require('chainsaw').variableLog() end },
			{ 'g?p', function() require('chainsaw').messageLog() end },
		},
	},
}
