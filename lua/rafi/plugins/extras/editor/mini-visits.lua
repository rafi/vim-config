return {

	-- Track and reuse file system visits
	{
		'echasnovski/mini.visits',
		event = 'VeryLazy',
		opts = {},
		-- stylua: ignore
		keys = {
			{ '<LocalLeader>l', '<cmd>lua MiniVisits.select_path()<CR>', 'Visits' },
		},
	},
}
