return {

	-- Debugging in NeoVim the print() way
	{
		'andrewferrier/debugprint.nvim',
		version = '*', -- Remove if you DON'T want to use the stable version
		cmd = { 'ToggleCommentDebugPrints', 'DeleteDebugPrints' },
		keys = {
			{ 'g?o', desc = 'Debug via text-obj below' },
			{ 'g?O', desc = 'Debug via text-obj above' },
			{ 'g?v', desc = 'Debug variable below' },
			{ 'g?V', desc = 'Debug variable above' },
			{ 'g?p', desc = 'Debug plain below' },
			{ 'g?P', desc = 'Debug plain above' },
		},
		opts = {
			keymaps = {
				normal = {
					plain_below = 'g?p',
					plain_above = 'g?P',
					variable_below = 'g?v',
					variable_above = 'g?V',
					variable_below_alwaysprompt = nil,
					variable_above_alwaysprompt = nil,
					textobj_below = 'g?o',
					textobj_above = 'g?O',
					toggle_comment_debug_prints = nil,
					delete_debug_prints = nil,
				},
				insert = {
					plain = nil, -- '<C-G>p',
					variable = nil, -- '<C-G>v',
				},
				visual = {
					variable_below = nil, -- 'g?v',
					variable_above = nil, -- 'g?V',
				},
			},
			commands = {
				toggle_comment_debug_prints = 'ToggleCommentDebugPrints',
				delete_debug_prints = 'DeleteDebugPrints',
			},
		},
	},
}
