-- plugin: telescope.nvim
-- see: https://github.com/nvim-telescope/telescope.nvim
-- rafi settings

local transform_mod = require('telescope.actions.mt').transform_mod
local actions = require('telescope.actions')
local telescope = require('telescope')

-- Custom actions

local myactions = {}

function myactions.send_to_qflist(prompt_bufnr)
	actions.send_to_qflist(prompt_bufnr)
	require('user').qflist.open()
end

function myactions.smart_send_to_qflist(prompt_bufnr)
	actions.smart_send_to_qflist(prompt_bufnr)
	require('user').qflist.open()
end

-- Transform to Telescope proper actions.
myactions = transform_mod(myactions)

-- Setup Telescope

telescope.setup{
	defaults = {
		prompt_prefix = ' ❯ ',
		selection_caret = '▷ ',

		-- scroll_strategy = 'cycle',
		selection_strategy = 'closest',
		sorting_strategy = 'ascending',

		winblend = 0,
		color_devicons = true,
		set_env = { COLORTERM = 'truecolor' },

		layout_strategy = 'horizontal',
		layout_config = {
			width = 0.8,
			height = 0.8,
			center = {
				preview_cutoff = 40
			},
			horizontal = {
				preview_cutoff = 120,
				prompt_position = 'top'
			},
			vertical = {
				preview_cutoff = 40
			},
		},
		-- 	horizontal = {
		-- 		width_padding = 0.1,
		-- 		height_padding = 0.1,
		-- 		preview_width = 0.6,
		-- 	},
		-- 	vertical = {
		-- 		width_padding = 0.05,
		-- 		height_padding = 1,
		-- 		preview_height = 0.5,
		-- 	}

		file_ignore_patterns = {},

		vimgrep_arguments = {
			'rg',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case',
		},

		mappings = {
			i = {
				["jj"] = { "<cmd>stopinsert<CR>", type = "command" },
				["<Tab>"] = actions.move_selection_worse,
				["<S-Tab>"] = actions.move_selection_better,
			  -- ["<Tab>"] = actions.move_selection_next,
			  -- ["<C-Tab>"] = actions.move_selection_previous,

				["<C-q>"] = myactions.smart_send_to_qflist,
			  ["<C-l"] = actions.complete_tag,

				-- insert_value
				-- insert_symbol
				-- run_builtin
				-- add_selected_to_qflist
				-- send_selected_to_qflist
				-- add_to_qflist
				-- send_to_qflist
				-- smart_send_to_qflist
				-- smart_add_to_qflist
				-- complete_tag
				-- open_qflist
			},
			n = {
				["q"] = actions.close,

				["<Tab>"] = actions.move_selection_worse,
				["<S-Tab>"] = actions.move_selection_better,

				["<Space>"] = actions.toggle_selection,
				["w"] = myactions.smart_send_to_qflist,
				["e"] = myactions.send_to_qflist,

				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,

				["sv"] = actions.select_horizontal,
				["sg"] = actions.select_vertical,
				["st"] = actions.select_tab,

				["!"] = actions.edit_command_line,
				["?"] = actions.edit_search_line,
			},
		},
	},
	pickers = {
		buffers = {
			theme = "dropdown",
			previewer = false,
			sort_lastused = true,
			show_all_buffers = true,
			mappings = {
				i = { ["<c-d>"] = actions.delete_buffer },
				n = { ["dd"] = actions.delete_buffer }
			}
		},
		find_files = {
			theme = "dropdown",
			previewer = false,
			layout_config = { width = 0.5, height = 0.7 },
			find_command = {
				'rg',
				'--smart-case',
				'--hidden',
				'--no-ignore-vcs',
				'--glob',
				'!.git',
				'--files',
			}
		},
		highlights = {
			layout_config = { preview_width = 0.80 },
		},
		jumplist = {
			layout_config = { preview_width = 0.60 },
		},
		command_history = {
			theme = "dropdown",
			layout_config = { width = 0.4, height = 0.5 },
		},
		search_history = {
			theme = "dropdown",
			layout_config = { width = 0.4, height = 0.5 },
		},
		spell_suggest = {
			theme = "dropdown",
			layout_config = { width = 0.2, height = 0.5 },
		},
		registers = {
			theme = "dropdown",
			previewer = false,
			layout_config = { width = 0.4, height = 0.6 },
		},
		oldfiles = {
			theme = "dropdown",
			previewer = false,
			layout_config = { width = 0.6, height = 0.5 },
		},
		lsp_code_actions = {
			theme = "dropdown",
			previewer = false,
			layout_config = { width = 0.3, height = 0.5 },
		},
		lsp_range_code_actions = {
			theme = "dropdown",
			previewer = false,
			layout_config = { width = 0.3, height = 0.5 },
		},
		vim_options = {
			theme = "dropdown",
			previewer = false,
			layout_config = { width = 0.5, height = 0.7 },
		},
	},
}

-- Telescope extensions

telescope.load_extension('zoxide')
telescope.load_extension('session-lens')

-- vim: set ts=2 sw=2 tw=80 noet :
