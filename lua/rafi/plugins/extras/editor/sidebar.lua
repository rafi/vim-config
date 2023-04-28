return {

	{
		'sidebar-nvim/sidebar.nvim',
		main = 'sidebar-nvim',
		cmd = { 'SidebarNvimToggle', 'SidebarNvimOpen' },
		opts = {
			open = true,
			bindings = {
				['q'] = function() require('sidebar-nvim').close() end
			}
		},
	},

}
