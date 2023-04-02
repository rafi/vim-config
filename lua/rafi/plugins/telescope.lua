-- Plugin: telescope.nvim
-- https://github.com/rafi/vim-config

-- Helpers

-- Custom actions

local myactions = {}

function myactions.send_to_qflist(prompt_bufnr)
	require('telescope.actions').send_to_qflist(prompt_bufnr)
	vim.api.nvim_command([[ botright copen ]])
end

function myactions.smart_send_to_qflist(prompt_bufnr)
	require('telescope.actions').smart_send_to_qflist(prompt_bufnr)
	vim.api.nvim_command([[ botright copen ]])
end

-- Custom pickers

local plugin_directories = function(opts)
	local actions = require('telescope.actions')
	local utils = require('telescope.utils')
	local dir = vim.fn.stdpath('data') .. '/lazy'

	opts = opts or {}
	opts.cmd = vim.F.if_nil(opts.cmd, {
		vim.o.shell,
		'-c',
		'find '..vim.fn.shellescape(dir)..' -mindepth 1 -maxdepth 1 -type d',
	})

	local dir_len = dir:len()
	opts.entry_maker = function(line)
		return {
			value = line,
			ordinal = line,
			display = line:sub(dir_len + 2),
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
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local entry = require('telescope.actions.state').get_selected_entry()
				actions.close(prompt_bufnr)
				vim.defer_fn(function() vim.cmd.lcd(entry.value) end, 300)
			end)
			return true
		end
	}):find()
end

-- Custom window-sizes

local width_small = function(_, cols, _)
	if cols > 200 then
		return math.floor(cols * 0.6)
	else
		return math.floor(cols * 0.5)
	end
end

local width_medium = function(_, cols, _)
	if cols > 200 then
		return math.floor(cols * 0.5)
	elseif cols > 110 then
		return math.floor(cols * 0.6)
	else
		return math.floor(cols * 0.75)
	end
end

local height_medium = function(_, _, rows)
	return math.floor(rows * 0.7)
end

-- Automatically hide statusline when using Telescope, if using globalstatus.
if vim.go.laststatus < 3 then
	vim.api.nvim_create_autocmd('FileType', {
		pattern = 'TelescopePrompt',
		group = vim.api.nvim_create_augroup('rafi_telescope', {}),
		callback = function(event)
			vim.go.laststatus = 0
			vim.api.nvim_create_autocmd('BufWinLeave', {
				buffer = event.buf,
				group = 'rafi_telescope',
				once = true,
				callback = function() vim.go.laststatus = 3 end
			})
		end
	})
end

-- Enable indent-guides in telescope preview
vim.api.nvim_create_autocmd('User', {
	pattern = 'TelescopePreviewerLoaded',
	group = 'rafi_telescope',
	callback = function()
		vim.wo.wrap = true
		vim.wo.list = true
		vim.wo.number = true
	end
})

-- Setup Telescope
-- See telescope.nvim/lua/telescope/config.lua for defaults.
return {

	-----------------------------------------------------------------------------
	{
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-ui-select.nvim',
			'jvgrootveld/telescope-zoxide',
			'folke/todo-comments.nvim',
			'rafi/telescope-thesaurus.nvim',
		},
		config = function(_, opts)
			require('telescope').setup(opts)
			require('telescope').load_extension('persisted')
			require('telescope').load_extension('ui-select')
		end,
		keys = {
			-- General pickers
			{ '<localleader>r', '<cmd>Telescope resume initial_mode=normal<CR>' },
			{ '<localleader>R', '<cmd>Telescope pickers<CR>' },
			{ '<localleader>f', '<cmd>Telescope find_files<CR>' },
			{ '<localleader>g', '<cmd>Telescope live_grep<CR>' },
			{ '<localleader>b', '<cmd>Telescope buffers show_all_buffers=true<CR>' },
			{ '<localleader>h', '<cmd>Telescope highlights<CR>' },
			{ '<localleader>j', '<cmd>Telescope jumplist<CR>' },
			{ '<localleader>m', '<cmd>Telescope marks<CR>' },
			{ '<localleader>o', '<cmd>Telescope vim_options<CR>' },
			{ '<localleader>t', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>' },
			{ '<localleader>v', '<cmd>Telescope registers<CR>' },
			{ '<localleader>u', '<cmd>Telescope spell_suggest<CR>' },
			{ '<localleader>s', '<cmd>Telescope persisted<CR>' },
			{ '<localleader>x', '<cmd>Telescope oldfiles<CR>' },
			{ '<localleader>;', '<cmd>Telescope command_history<CR>' },
			{ '<localleader>:', '<cmd>Telescope commands<CR>' },
			{ '<localleader>/', '<cmd>Telescope search_history<CR>' },
			{ '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<CR>' },

			{ '<leader>sd', '<cmd>Telescope diagnostics<CR>', desc = 'Diagnostics' },
			{ '<leader>sh', '<cmd>Telescope help_tags<CR>', desc = 'Help Pages' },
			{ '<leader>sk', '<cmd>Telescope keymaps<CR>', desc = 'Key Maps' },
			{ '<leader>sm', '<cmd>Telescope man_pages<CR>', desc = 'Man Pages' },
			{ '<leader>sw', '<cmd>Telescope grep_string<CR>', desc = 'Word' },
			{ '<leader>sc', '<cmd>Telescope colorscheme<CR>', desc = 'Colorscheme' },

			-- LSP related
			{ '<localleader>dd', '<cmd>Telescope lsp_definitions<CR>' },
			{ '<localleader>di', '<cmd>Telescope lsp_implementations<CR>' },
			{ '<localleader>dr', '<cmd>Telescope lsp_references<CR>' },
			{ '<localleader>da', '<cmd>Telescope lsp_code_actions<CR>' },
			{ '<localleader>da', ':Telescope lsp_range_code_actions<CR>', mode = 'x' },
			{
				'<leader>ss',
				function()
					require('telescope.builtin').lsp_document_symbols({
						symbols = {
							'Class',
							'Function',
							'Method',
							'Constructor',
							'Interface',
							'Module',
							'Struct',
							'Trait',
							'Field',
							'Property',
						},
					})
				end,
				desc = 'Goto Symbol',
			},
			{
				'<leader>sS',
				function()
					require('telescope.builtin').lsp_workspace_symbols({
						symbols = {
							'Class',
							'Function',
							'Method',
							'Constructor',
							'Interface',
							'Module',
							'Struct',
							'Trait',
							'Field',
							'Property',
						},
					})
				end,
				desc = 'Goto Symbol (Workspace)',
			},

			-- Git
			{ '<leader>gs', '<cmd>Telescope git_status<CR>' },
			{ '<leader>gr', '<cmd>Telescope git_branches<CR>' },
			{ '<leader>gl', '<cmd>Telescope git_commits<CR>' },
			{ '<leader>gL', '<cmd>Telescope git_bcommits<CR>' },
			{ '<leader>gh', '<cmd>Telescope git_stash<CR>' },

			-- Plugins
			{ '<localleader>n', plugin_directories },
			{ '<localleader>k', '<cmd>Telescope thesaurus lookup<CR>' },
			{ '<localleader>w', '<cmd>ZkNotes<CR>' },

			{
				'<localleader>z',
				function()
					require('telescope').extensions.zoxide.list({
						layout_config = { width = 0.5, height = 0.6 },
					})
				end,
			},

			-- Find by...
			{
				'<leader>gt',
				function()
					require('telescope.builtin').lsp_workspace_symbols({
						default_text = vim.fn.expand('<cword>'),
					})
				end,
			},
			{
				'<leader>gf',
				function()
					require('telescope.builtin').find_files({
						default_text = vim.fn.expand('<cword>'),
					})
				end,
			},
			{
				'<leader>gg', function()
					require('telescope.builtin').live_grep({
						default_text = vim.fn.expand('<cword>'),
					})
				end
			},
			{
				'<leader>gg',
				function()
					require('telescope.builtin').live_grep({
						default_text = require('rafi.lib.edit').get_visual_selection(),
					})
				end,
				mode = 'x',
			},

		},
		opts = function()
			local transform_mod = require('telescope.actions.mt').transform_mod
			local actions = require('telescope.actions')

			-- Transform to Telescope proper actions.
			myactions = transform_mod(myactions)

			return {
			defaults = {
				sorting_strategy = 'ascending',
				cache_picker = { num_pickers = 3 },

				prompt_prefix = '   ',  -- ❯  
				selection_caret = '▍ ',
				multi_icon = ' ',

				path_display = { 'truncate' },
				file_ignore_patterns = { 'node_modules' },
				set_env = { COLORTERM = 'truecolor' },

				-- Flex layout swaps between horizontal and vertical strategies
				-- based on the window width. See :h telescope.layout
				layout_strategy = 'flex',
				layout_config = {
					width = 0.9,
					height = 0.85,
					prompt_position = 'top',
					horizontal = {
						preview_width = width_small,
					},
					vertical = {
						width = 0.75,
						height = 0.85,
						preview_height = 0.4,
						mirror = true,
					},
					flex = {
						-- Change to horizontal after 120 cols
						flip_columns = 120,
					},
				},

				mappings = {

					i = {
						['jj'] = { '<Esc>', type = 'command' },

						['<Tab>'] = actions.move_selection_worse,
						['<S-Tab>'] = actions.move_selection_better,
						['<C-u>'] = actions.results_scrolling_up,
						['<C-d>'] = actions.results_scrolling_down,

						['<C-q>'] = myactions.smart_send_to_qflist,

						['<C-n>'] = actions.cycle_history_next,
						['<C-p>'] = actions.cycle_history_prev,

						['<C-b>'] = actions.preview_scrolling_up,
						['<C-f>'] = actions.preview_scrolling_down,
					},

					n = {
						['q']     = actions.close,
						['<Esc>'] = actions.close,

						['<Tab>'] = actions.move_selection_worse,
						['<S-Tab>'] = actions.move_selection_better,
						['<C-u>'] = actions.results_scrolling_up,
						['<C-d>'] = actions.results_scrolling_down,

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

						['sv'] = actions.select_horizontal,
						['sg'] = actions.select_vertical,
						['st'] = actions.select_tab,

						['w'] = myactions.smart_send_to_qflist,
						['e'] = myactions.send_to_qflist,

						['!'] = actions.edit_command_line,

						['t'] = function(...)
							return require('trouble.providers.telescope').open_with_trouble(...)
						end,

						['p'] = function()
							local entry = require('telescope.actions.state').get_selected_entry()
							require('rafi.lib.preview').open(entry.path)
						end,
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
					layout_config = { width = width_medium, height = height_medium },
					mappings = {
						n = {
							['dd'] = actions.delete_buffer,
						}
					}
				},
				find_files = {
					theme = 'dropdown',
					previewer = false,
					layout_config = { width = width_medium, height = height_medium },
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
					layout_config = { width = 0.45, height = 0.8 },
				},
				highlights = {
					layout_strategy = 'horizontal',
					layout_config = { preview_width = 0.8 },
				},
				jumplist = {
					layout_strategy = 'horizontal',
				},
				vim_options = {
					theme = 'dropdown',
					layout_config = { width = width_medium, height = height_medium },
				},
				command_history = {
					theme = 'dropdown',
					previewer = false,
					layout_config = { width = 0.5, height = height_medium },
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
					layout_config = { width = 0.35, height = 0.4 },
				},
				oldfiles = {
					theme = 'dropdown',
					previewer = false,
					layout_config = { width = width_medium, height = height_medium },
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
				persisted = {
					layout_config = {
						width = 0.55, height = 0.55,
					},
				},
				zoxide = {
					prompt_title = '[ Zoxide directories ]',
					mappings = {
						default = {
							action = function(selection)
								vim.defer_fn(function() vim.cmd.lcd(selection.path) end, 300)
							end,
							after_action = function(selection)
								vim.notify(
									"Current working directory set to '"..selection.path.."'",
									vim.log.levels.INFO
								)
							end
						},
					},
				},
				['ui-select'] = {
					require('telescope.themes').get_cursor({
						layout_config = { width = 0.35, height = 0.35 },
					})
				},
			}
		}
		end
	},

}
