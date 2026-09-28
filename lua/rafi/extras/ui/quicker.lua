return {

	-----------------------------------------------------------------------------
	-- Better quickfix window
	{
		'stevearc/quicker.nvim',
		ft = 'qf',
		event = 'QuickFixCmdPost',
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {
			edit = {
				enabled = false,
				autosave = false,
			},
			highlight = {
				lsp = false,
				load_buffers = false,
			},
			-- stylua: ignore
			keys = {
				{ '>', function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end, desc = 'Expand quickfix context' },
				{ '<', function() require('quicker').collapse() end, desc = 'Collapse quickfix context' },
			},
		},
	},
}
