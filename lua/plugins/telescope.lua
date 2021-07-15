-- plugin: telescope.nvim
-- see: https://github.com/nvim-telescope/telescope.nvim
-- rafi settings

-- Global mappings preload
local preload = function()
	local keymap = vim.api.nvim_set_keymap
	local opts = { noremap = true, silent = true }

	-- General pickers
	keymap('n', '<localleader>f', '<cmd>Telescope find_files<cr>', opts)
	keymap('n', '<localleader>g', '<cmd>Telescope live_grep<CR>', opts)
	keymap('n', '<localleader>b', '<cmd>Telescope buffers<CR>', opts)
	keymap('n', '<localleader>h', '<cmd>Telescope highlights<CR>', opts)
	keymap('n', '<localleader>j', '<cmd>Telescope jumplist<CR>', opts)
	keymap('n', '<localleader>m', '<cmd>Telescope marks<CR>', opts)
	keymap('n', '<localleader>o', '<cmd>Telescope vim_options<CR>', opts)
	keymap('n', '<localleader>t', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', opts)
	keymap('n', '<localleader>v', '<cmd>Telescope registers<CR>', opts)
	keymap('n', '<localleader>u', '<cmd>Telescope spell_suggest<CR>', opts)
	keymap('n', '<localleader>s', '<cmd>Telescope session-lens search_session<CR>', opts)
	keymap('n', '<localleader>x', '<cmd>Telescope oldfiles<CR>', opts)
	keymap('n', '<localleader>z', '<cmd>lua require"plugins.telescope".pickers.zoxide()<CR>', opts)
	keymap('n', '<localleader>;', '<cmd>Telescope command_history<CR>', opts)
	keymap('n', '<localleader>/', '<cmd>Telescope search_history<CR>', opts)

	-- git_commits    git_bcommits   git_branches
	-- git_status     git_stash      git_files
	-- file_browser   tags           fd             autocommands   quickfix
	-- filetypes      commands       man_pages      help_tags      loclist
	-- lsp_workspace_diagnostics     lsp_document_diagnostics

	-- Location-specific find files/directories
	keymap('n', '<localleader>n', '<cmd>lua require"plugins.telescope".pickers.plugin_directories()<CR>', opts)
	keymap('n', '<localleader>w', '<cmd>lua require"plugins.telescope".pickers.notebook()<CR>', opts)

	-- Navigation
	keymap('n', '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
	keymap('n', '<leader>gt', '<cmd>lua require"plugins.telescope".pickers.lsp_workspace_symbols_cursor()<CR>', opts)
	keymap('n', '<leader>gf', '<cmd>lua require"plugins.telescope".pickers.find_files_cursor()<CR>', opts)
	keymap('n', '<leader>gg', '<cmd>lua require"plugins.telescope".pickers.grep_string_cursor()<CR>', opts)
	keymap('v', '<leader>gg', '<cmd>lua require"plugins.telescope".pickers.grep_string_visual()<CR>', opts)

	-- LSP related
	keymap('n', '<localleader>dd', '<cmd>Telescope lsp_definitions<CR>', opts)
	keymap('n', '<localleader>di', '<cmd>Telescope lsp_implementations<CR>', opts)
	keymap('n', '<localleader>dr', '<cmd>Telescope lsp_references<CR>', opts)
	keymap('n', '<localleader>da', '<cmd>Telescope lsp_code_actions<CR>', opts)
	keymap('v', '<localleader>da', '<cmd>Telescope lsp_range_code_actions<CR>', opts)
end

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
	require'telescope.builtin'.live_grep({ default_text = visual_selection() })
end

pickers.grep_string_cursor = function()
	require'telescope.builtin'.live_grep({ default_text = vim.fn.expand('<cword>') })
end

pickers.find_files_cursor = function()
	require'telescope.builtin'.find_files({ default_text = vim.fn.expand('<cword>') })
end

pickers.lsp_workspace_symbols_cursor = function()
	require'telescope.builtin'.lsp_workspace_symbols({ default_text = vim.fn.expand('<cword>') })
end

pickers.zoxide = function()
	require'telescope'.extensions.zoxide.list({
		layout_config = {
			width = 0.5,
			height = 0.6,
		},
	})
end

pickers.notebook = function()
	require'telescope.builtin'.find_files({
		prompt_title = '[ Notebook ]',
		cwd = '$HOME/docs/blog',
	})
end

pickers.plugin_directories = function(opts)
	local utils = require('telescope.utils')
	local dir = vim.fn.expand('$XDG_DATA_HOME/nvim/dein/repos/github.com')

	opts = opts or {}
	opts.cmd = utils.get_default(opts.cmd, {
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
		attach_mappings = function(prompt_bufnr, map)
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

-- On-demand setup
local setup = function()
	local telescope = require('telescope')
	local transform_mod = require('telescope.actions.mt').transform_mod
	local actions = require('telescope.actions')

	-- Transform to Telescope proper actions.
	myactions = transform_mod(myactions)

	local no_previewer_mappings = {
		i = {
			['<C-u>'] = myactions.page_up,
			['<C-d>'] = myactions.page_down,
		},
		n = {
			['<C-u>'] = myactions.page_up,
			['<C-d>'] = myactions.page_down,
		},
	}

	-- Setup Telescope
	telescope.setup{
		defaults = {
			prompt_prefix = '❯ ',
			selection_caret = '▷ ',
			selection_strategy = 'closest',
			sorting_strategy = 'ascending',
			scroll_strategy = 'cycle',
			color_devicons = true,
			winblend = 0,
			set_env = { COLORTERM = 'truecolor' },

			layout_strategy = 'flex',
			-- layout_strategy = 'horizontal',
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
					['jj'] = { '<esc>', type = 'command' },
					-- ['jj'] = { '<cmd>stopinsert<CR>', type = 'command' },
					['<Tab>'] = actions.move_selection_worse,
					['<S-Tab>'] = actions.move_selection_better,
					-- ['<Tab>'] = actions.move_selection_next,
					-- ['<C-Tab>'] = actions.move_selection_previous,

					['<C-q>'] = myactions.smart_send_to_qflist,
					['<C-l'] = actions.complete_tag,

					['<Down>'] = require('telescope.actions').cycle_history_next,
					['<Up>'] = require('telescope.actions').cycle_history_prev,

					-- insert_value
					-- insert_symbol
					-- run_builtin
					-- complete_tag
					-- open_qflist
				},
				n = {
					['q']     = actions.close,
					['<Esc>'] = actions.close,

					['<Tab>']   = actions.move_selection_worse,
					['<S-Tab>'] = actions.move_selection_better,

					['J'] = actions.toggle_selection + actions.move_selection_next,
					['K'] = actions.toggle_selection + actions.move_selection_previous,
					['<Space>'] = {
						actions.toggle_selection,
						type = 'action',
						-- See https://github.com/nvim-telescope/telescope.nvim/pull/890
						options = { nowait = true },
					},
					['*'] = actions.toggle_all,
					['u'] = actions.drop_all,

					['gg'] = actions.move_to_top,
					['G'] = actions.move_to_bottom,

					['sv'] = actions.select_horizontal,
					['sg'] = actions.select_vertical,
					['st'] = actions.select_tab,

					['w'] = myactions.smart_send_to_qflist,
					['e'] = myactions.send_to_qflist,

					['!'] = actions.edit_command_line,
					['?'] = actions.edit_search_line,
				},
			},
		},
		pickers = {
			buffers = {
				theme = 'dropdown',
				previewer = false,
				sort_lastused = true,
				show_all_buffers = true,
				ignore_current_buffer = true,
				layout_config = { width = width_for_nopreview, height = height_dropdown_nopreview },
				mappings = {
					n = { ['dd'] = actions.delete_buffer }
				}
			},
			find_files = {
				theme = 'dropdown',
				previewer = false,
				layout_config = { width = width_for_nopreview, height = height_dropdown_nopreview },
				mappings = no_previewer_mappings,
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
				layout_strategy = 'horizontal',
				layout_config = { preview_width = 0.80 },
			},
			jumplist = {
				layout_strategy = 'horizontal',
				layout_config = { preview_width = 0.60 },
			},
			vim_options = {
				theme = 'dropdown',
				previewer = false,
				layout_config = { width = 0.5, height = 0.7 },
				mappings = no_previewer_mappings,
			},
			command_history = {
				theme = 'dropdown',
				previewer = false,
				layout_config = { width = 0.5, height = 0.7 },
				mappings = no_previewer_mappings,
			},
			search_history = {
				theme = 'dropdown',
				layout_config = { width = 0.4, height = 0.6 },
				mappings = no_previewer_mappings,
			},
			spell_suggest = {
				theme = 'dropdown',
				layout_config = { width = 0.2, height = 0.7 },
				mappings = no_previewer_mappings,
			},
			registers = {
				theme = 'dropdown',
				previewer = false,
				layout_config = { width = 0.5, height = 0.7 },
				mappings = no_previewer_mappings,
			},
			oldfiles = {
				theme = 'dropdown',
				previewer = false,
				-- path_display = 'shorten',
				layout_config = { width = width_for_nopreview, height = height_dropdown_nopreview },
				mappings = no_previewer_mappings,
			},
			lsp_code_actions = {
				theme = 'dropdown',
				previewer = false,
				layout_config = { width = 0.3, height = 0.4 },
				mappings = no_previewer_mappings,
			},
			lsp_range_code_actions = {
				theme = 'dropdown',
				previewer = false,
				layout_config = { width = 0.3, height = 0.4 },
				mappings = no_previewer_mappings,
			},
		},
	}

	-- Telescope extensions are loaded in each plugin.
end

-- Public functions
return {
	setup = setup,
	preload = preload,
	pickers = pickers,
}

-- vim: set ts=2 sw=2 tw=80 noet :
