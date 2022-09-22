-- plugin: telescope.nvim
-- see: https://github.com/nvim-telescope/telescope.nvim
-- rafi settings

-- Helpers

-- Returns visually selected text
local visual_selection = function()
	local save_previous = vim.fn.getreg('a')
	vim.api.nvim_command('silent! normal! "ay')
	local selection = vim.fn.trim(vim.fn.getreg('a'))
	vim.fn.setreg('a', save_previous)
	return vim.fn.substitute(selection, [[\n]], [[\\n]], 'g')
end

-- Custom actions

local myactions = {}

function myactions.send_to_qflist(prompt_bufnr)
	require('telescope.actions').send_to_qflist(prompt_bufnr)
	require('user').qflist.open()
end

function myactions.smart_send_to_qflist(prompt_bufnr)
	require('telescope.actions').smart_send_to_qflist(prompt_bufnr)
	require('user').qflist.open()
end

function myactions.page_up(prompt_bufnr)
	require('telescope.actions.set').shift_selection(prompt_bufnr, -5)
end

function myactions.page_down(prompt_bufnr)
	require('telescope.actions.set').shift_selection(prompt_bufnr, 5)
end

function myactions.change_directory(prompt_bufnr)
	local entry = require('telescope.actions.state').get_selected_entry()
	require('telescope.actions').close(prompt_bufnr)
	vim.cmd('lcd ' .. entry.path)
end

-- Custom pickers

local pickers = {}

pickers.grep_string_visual = function()
	require'telescope.builtin'.live_grep({
		default_text = visual_selection(),
	})
end

pickers.grep_string_cursor = function()
	require'telescope.builtin'.live_grep({
		default_text = vim.fn.expand('<cword>'),
	})
end

pickers.find_files_cursor = function()
	require'telescope.builtin'.find_files({
		default_text = vim.fn.expand('<cword>'),
	})
end

pickers.lsp_workspace_symbols_cursor = function()
	require'telescope.builtin'.lsp_workspace_symbols({
		default_text = vim.fn.expand('<cword>'),
	})
end

pickers.zoxide = function()
	require('telescope').extensions.zoxide.list({
		layout_config = {
			width = 0.5,
			height = 0.6,
		},
	})
end

pickers.plugin_directories = function(opts)
	local utils = require('telescope.utils')
	local dir = vim.fn.expand('$VIM_DATA_PATH/dein/repos/github.com')

	opts = opts or {}
	opts.cmd = vim.F.if_nil(opts.cmd, {
		vim.o.shell,
		'-c',
		'find '..vim.fn.shellescape(dir)..' -mindepth 2 -maxdepth 2 -type d',
	})

	local dir_len = dir:len()
	opts.entry_maker = function(line)
		return {
			value = line,
			ordinal = line,
			display = line:sub(dir_len + 2),
			path = line,
		}
	end

	require('telescope.pickers').new(opts, {
		layout_config = {
			width = 0.65,
			height = 0.7,
		},
		prompt_title = '[ Plugin directories ]',
		finder = require('telescope.finders').new_table{
			results = utils.get_os_command_output(opts.cmd),
			entry_maker = opts.entry_maker,
		},
		sorter = require('telescope.sorters').get_fuzzy_file(),
		previewer = require('telescope.previewers.term_previewer').cat.new(opts),
		attach_mappings = function(_, map)
			map('i', '<cr>', myactions.change_directory)
			map('n', '<cr>', myactions.change_directory)
			return true
		end
	}):find()
end

-- Custom window-sizes

local horizontal_preview_width = function(_, cols, _)
	if cols > 200 then
		return math.floor(cols * 0.7)
	else
		return math.floor(cols * 0.6)
	end
end

local width_for_nopreview = function(_, cols, _)
	if cols > 200 then
		return math.floor(cols * 0.5)
	elseif cols > 110 then
		return math.floor(cols * 0.6)
	else
		return math.floor(cols * 0.75)
	end
end

local height_dropdown_nopreview = function(_, _, rows)
	return math.floor(rows * 0.7)
end

-- Enable indent-guides in telescope preview
vim.cmd [[
	augroup telescope_events
		autocmd!
		autocmd User TelescopePreviewerLoaded setlocal wrap list number
	augroup END
]]

-- On-demand setup
local setup = function()
	local telescope = require('telescope')
	local transform_mod = require('telescope.actions.mt').transform_mod
	local actions = require('telescope.actions')

	-- Transform to Telescope proper actions.
	myactions = transform_mod(myactions)

	-- Setup Telescope
	-- See telescope.nvim/lua/telescope/config.lua for defaults.
	telescope.setup{
		defaults = {
			sorting_strategy = 'ascending',
			-- selection_strategy = 'follow',
			scroll_strategy = 'cycle',
			cache_picker = {
				num_pickers = 3,
				limit_entries = 300,
			},

			prompt_prefix = "   ",
			-- prompt_prefix = '❯ ',
			selection_caret = '▍ ',
			multi_icon = '‣',

			file_ignore_patterns = { 'node_modules' },
			set_env = { COLORTERM = 'truecolor' },

			-- Flex layout swaps between horizontal and vertical strategies
			-- based on the window width. See :h telescope.layout
			layout_strategy = 'flex',
			layout_config = {
				width = 0.9,
				height = 0.85,
				prompt_position = 'top',
				-- center = {
				-- 	preview_cutoff = 40
				-- },
				horizontal = {
					-- width_padding = 0.1,
					-- height_padding = 0.1,
					-- preview_cutoff = 60,
					preview_width = horizontal_preview_width,
				},
				vertical = {
					-- width_padding = 0.05,
					-- height_padding = 1,
					width = 0.75,
					height = 0.85,
					preview_height = 0.4,
					mirror = true,
				},
				flex = {
					-- change to horizontal after 120 cols
					flip_columns = 120,
				},
			},

			mappings = {

				i = {
					['jj'] = { '<Esc>', type = 'command' },

					['<Tab>'] = actions.move_selection_next,
					['<S-Tab>'] = actions.move_selection_previous,
					['<C-u>'] = myactions.page_up,
					['<C-d>'] = myactions.page_down,

					['<C-q>'] = myactions.smart_send_to_qflist,
					-- ['<C-l'] = actions.complete_tag,

					['<Down>'] = actions.cycle_history_next,
					['<Up>'] = actions.cycle_history_prev,
					['<C-n>'] = actions.cycle_history_next,
					['<C-p>'] = actions.cycle_history_prev,

					['<C-b>'] = actions.preview_scrolling_up,
					['<C-f>'] = actions.preview_scrolling_down,
				},

				n = {
					['q']     = actions.close,
					['<Esc>'] = actions.close,

					['<Tab>']   = actions.move_selection_next,
					['<S-Tab>'] = actions.move_selection_previous,
					['<C-u>'] = myactions.page_up,
					['<C-d>'] = myactions.page_down,

					['<C-b>'] = actions.preview_scrolling_up,
					['<C-f>'] = actions.preview_scrolling_down,

					['<C-n>'] = actions.cycle_history_next,
					['<C-p>'] = actions.cycle_history_prev,

					['*'] = actions.toggle_all,
					['u'] = actions.drop_all,
					['J'] = actions.toggle_selection + actions.move_selection_next,
					['K'] = actions.toggle_selection + actions.move_selection_previous,
					[' '] = {
						actions.toggle_selection + actions.move_selection_next,
						type = 'action',
						opts = { nowait = true },
					},

					['gg'] = actions.move_to_top,
					['G'] = actions.move_to_bottom,

					['sv'] = actions.select_horizontal,
					['sg'] = actions.select_vertical,
					['st'] = actions.select_tab,
					['l'] = actions.select_default,

					['w'] = myactions.smart_send_to_qflist,
					['e'] = myactions.send_to_qflist,

					['!'] = actions.edit_command_line,
				},

			},
		},
		pickers = {
			buffers = {
				theme = 'dropdown',
				previewer = false,
				sort_lastused = true,
				sort_mru = true,
				show_all_buffers = true,
				ignore_current_buffer = true,
				path_display = { truncate = 3 },
				layout_config = {
					width = width_for_nopreview,
					height = height_dropdown_nopreview,
				},
				mappings = {
					n = {
						['dd'] = actions.delete_buffer,
					}
				}
			},
			find_files = {
				theme = 'dropdown',
				previewer = false,
				layout_config = {
					width = width_for_nopreview,
					height = height_dropdown_nopreview,
				},
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
			live_grep = {
				dynamic_preview_title = true,
			},
			colorscheme = {
				enable_preview = true,
				-- previewer = false,
				-- theme = 'dropdown',
				layout_config = { width = 0.45, height = 0.8 },
			},
			highlights = {
				layout_strategy = 'horizontal',
				layout_config = { preview_width = 0.80 },
			},
			-- jumplist = {
			-- 	layout_strategy = 'horizontal',
			-- 	layout_config = { preview_width = 0.60 },
			-- },
			vim_options = {
				theme = 'dropdown',
				previewer = false,
				layout_config = { width = 0.6, height = 0.7 },
			},
			command_history = {
				theme = 'dropdown',
				previewer = false,
				layout_config = { width = 0.5, height = 0.7 },
			},
			search_history = {
				theme = 'dropdown',
				layout_config = { width = 0.4, height = 0.6 },
			},
			spell_suggest = {
				theme = 'cursor',
				layout_config = { width = 0.27, height = 0.45 },
			},
			registers = {
				theme = 'cursor',
				previewer = false,
				layout_config = { width = 0.45, height = 0.6 },
			},
			oldfiles = {
				theme = 'dropdown',
				previewer = false,
				path_display= { shorten = 5 },
				layout_config = {
					width = width_for_nopreview,
					height = height_dropdown_nopreview,
				},
			},
			lsp_definitions = {
				layout_strategy = 'horizontal',
				layout_config = { width = 0.7, height = 0.8, preview_width = 0.45 },
			},
			lsp_implementations = {
				layout_strategy = 'horizontal',
				layout_config = { width = 0.7, height = 0.8, preview_width = 0.45 },
			},
			lsp_references = {
				layout_strategy = 'horizontal',
				layout_config = { width = 0.7, height = 0.8, preview_width = 0.45 },
			},
			lsp_code_actions = {
				theme = 'cursor',
				previewer = false,
				layout_config = { width = 0.3, height = 0.4 },
			},
			lsp_range_code_actions = {
				theme = 'cursor',
				previewer = false,
				layout_config = { width = 0.3, height = 0.4 },
			},
		},
		extensions = {
			zoxide = {
				prompt_title = '[ Zoxide directories ]',
				mappings = {
					default = {
						action = function(selection)
							vim.cmd.lcd(selection.path)
						end,
						after_action = function(_) end,
					},
				},
			},
			['ui-select'] = {
				require('telescope.themes').get_cursor {
					layout_config = { width = 0.35, height = 0.35 },
				}
			},
		}
	}

	-- Telescope extensions are loaded in each plugin.
end

-- Public functions
return {
	setup = setup,
	pickers = pickers,
}

-- vim: set ts=2 sw=2 tw=80 noet :
