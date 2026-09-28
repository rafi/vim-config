return {

	-- Track and reuse file system visits
	{
		'nvim-mini/mini.visits',
		event = 'VeryLazy',
		opts = {},
		-- stylua: ignore
		keys = {
			{ '<local>h', '<cmd>lua MiniVisits.select_path()<CR>', 'Visits' },
		},
	},
}
