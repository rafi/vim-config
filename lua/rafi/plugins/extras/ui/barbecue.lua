return {

	-- VS Code like winbar
	{
		'utilyre/barbecue.nvim',
		dependencies = { 'SmiteshP/nvim-navic' },
		keys = {
			{
				'<Leader>uB',
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
			end, LazyVim.config.icons.kinds)
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
