return {
	{
		'sidebar-nvim/sidebar.nvim',
		main = 'sidebar-nvim',
		cmd = { 'SidebarNvimToggle', 'SidebarNvimOpen' },
		opts = {
			open = true,
			bindings = {
				-- stylua: ignore
				['q'] = function() require('sidebar-nvim').close() end,
			},
		},
	},
}
