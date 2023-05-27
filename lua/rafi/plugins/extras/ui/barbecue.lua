return {
	{
		'utilyre/barbecue.nvim',
		dependencies = { 'SmiteshP/nvim-navic', 'nvim-tree/nvim-web-devicons' },
		keys = {
			{
				'<Leader>ub',
				function()
					local off = vim.b['barbecue_entries'] == nil
					require('barbecue.ui').toggle(off and true or nil)
				end,
				desc = 'Breadcrumbs toggle',
			},
		},
		opts = function()
			local kind_icons = vim.tbl_map(function(icon)
				return vim.trim(icon)
			end, require('rafi.config').icons.kinds)
			return {
				attach_navic = false,
				show_dirname = false,
				show_modified = true,
				kinds = kind_icons,
				symbols = { separator = '' },
			}
		end,
	},
}
