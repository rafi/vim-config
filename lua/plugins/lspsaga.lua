-- lspsaga
-- see: https://github.com/glepnir/lspsaga.nvim
-- rafi settings

require 'lspsaga'.init_lsp_saga {
	use_saga_diagnostic_sign = false,
	max_preview_lines = 10,
	border_style = 'round', -- single, double, round, plus
	code_action_prompt = {
		enable = false,
		sign = false,
		sign_priority = 20,
		virtual_text = false,
	},
	-- code_action_icon = ' ',
	-- dianostic_header_icon = '   ',
	-- definition_preview_icon = '  '
	-- finder_definition_icon = '  ',
	-- finder_reference_icon = '  ',
	-- rename_prompt_prefix = '➤',
	finder_action_keys = {
		open = 'o', -- {'o', '<CR>'},
		vsplit = 'sg', -- {'s', 'sg'},
		split = 'sv', -- {'i', 'sv'},
		quit = {'q', '<Esc>'},
		scroll_down = '<C-d>', -- {'<C-f>', '<C-d>'},
		scroll_up = '<C-u>', -- {'<C-b>', '<C-u>'},
	},
	code_action_keys = {
		quit = {'q', '<Esc>'},
		exec = '<CR>',
	},
	rename_action_keys = {
		quit = {'<C-c>', '<Esc>'},
		exec = '<CR>',
	},
}
