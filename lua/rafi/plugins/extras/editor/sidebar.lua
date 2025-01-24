return {

	-- Generic and modular lua sidebar
	{
		'sidebar-nvim/sidebar.nvim',
		main = 'sidebar-nvim',
		cmd = { 'SidebarNvimToggle', 'SidebarNvimOpen' },
		opts = {
			open = true,
			-- stylua: ignore
			bindings = {
				['q'] = function() require('sidebar-nvim').close() end,
			},
		},
	},
}
