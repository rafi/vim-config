return {

	-- Interacting with and manipulating marks
	{
		'chentoast/marks.nvim',
		event = 'FileType',
		-- stylua: ignore
		keys = {
			{ 'm/', '<cmd>MarksListAll<CR>', desc = 'Marks from all opened buffers' },
		},
		opts = {
			sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
			bookmark_1 = { sign = '󰈼' }, -- ⚐ ⚑ 󰈻 󰈼 󰈽 󰈾 󰈿 󰉀
			mappings = {
				annotate = 'm<Space>',
			},
		},
	},
}
