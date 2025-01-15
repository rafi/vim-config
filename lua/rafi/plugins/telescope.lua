-- Plugin: telescope.nvim
-- https://github.com/rafi/vim-config

if lazyvim_docs then
	-- In case you don't want to use `:LazyExtras`,
	-- then you need to set the option below.
	vim.g.lazyvim_picker = 'telescope'
end

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

--- Scroll the results window up
---@param prompt_bufnr number: The prompt bufnr
function myactions.results_scrolling_up(prompt_bufnr)
	myactions.scroll_results(prompt_bufnr, -1)
end

--- Scroll the results window down
---@param prompt_bufnr number: The prompt bufnr
function myactions.results_scrolling_down(prompt_bufnr)
	myactions.scroll_results(prompt_bufnr, 1)
end

---@param prompt_bufnr number: The prompt bufnr
---@param direction number: 1|-1
function myactions.scroll_results(prompt_bufnr, direction)
	local status = require('telescope.state').get_status(prompt_bufnr)
	local default_speed = vim.api.nvim_win_get_height(status.results_win) / 2
	local speed = status.picker.layout_config.scroll_speed or default_speed

	require('telescope.actions.set').shift_selection(
		prompt_bufnr,
		math.floor(speed) * direction
	)
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
		'find ' .. vim.fn.shellescape(dir) .. ' -mindepth 1 -maxdepth 1 -type d',
	})

	local dir_len = dir:len()
	opts.entry_maker = function(line)
		return {
			value = line,
			ordinal = line,
			display = line:sub(dir_len + 2),
		}
	end

	require('telescope.pickers')
		.new(opts, {
			layout_config = {
				width = 0.65,
				height = 0.7,
			},
			prompt_title = '[ Plugin directories ]',
			finder = require('telescope.finders').new_table({
				results = utils.get_os_command_output(opts.cmd),
				entry_maker = opts.entry_maker,
			}),
			sorter = require('telescope.sorters').get_fuzzy_file(),
			previewer = require('telescope.previewers.term_previewer').cat.new(opts),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local entry = require('telescope.actions.state').get_selected_entry()
					actions.close(prompt_bufnr)
					vim.cmd.tcd(entry.value)
				end)
				return true
			end,
		})
		:find()
end

-- Custom window-sizes
---@param dimensions table
---@param size integer
---@return number
local function get_matched_ratio(dimensions, size)
	for min_cols, scale in pairs(dimensions) do
		if min_cols == 'lower' or size >= min_cols then
			return math.floor(size * scale)
		end
	end
	return dimensions.lower
end

local function width_tiny(_, cols, _)
	return get_matched_ratio({ [180] = 0.27, lower = 0.37 }, cols)
end

local function width_small(_, cols, _)
	return get_matched_ratio({ [180] = 0.4, lower = 0.5 }, cols)
end

local function width_medium(_, cols, _)
	return get_matched_ratio({ [180] = 0.5, [110] = 0.6, lower = 0.75 }, cols)
end

local function width_large(_, cols, _)
	return get_matched_ratio({ [180] = 0.7, [110] = 0.8, lower = 0.85 }, cols)
end

-- Enable indent-guides in telescope preview
vim.api.nvim_create_autocmd('User', {
	pattern = 'TelescopePreviewerLoaded',
	group = vim.api.nvim_create_augroup('rafi_telescope', {}),
	callback = function(args)
		if args.buf ~= vim.api.nvim_win_get_buf(0) then
			return
		end
		vim.opt_local.listchars = vim.wo.listchars .. ',tab:▏\\ '
		vim.opt_local.list = true
		vim.opt_local.number = true
	end,
})

-- Setup Telescope
-- See telescope.nvim/lua/telescope/config.lua for defaults.
return {

	{
		import = 'lazyvim.plugins.extras.editor.telescope',
	},

	-----------------------------------------------------------------------------
	-- Find, Filter, Preview, Pick. All lua.
	{
		'nvim-telescope/telescope.nvim',
		version = false,
		cmd = 'Telescope',
		enabled = function()
			return LazyVim.pick.want() == 'telescope'
		end,
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- Telescope extension for Zoxide
			'jvgrootveld/telescope-zoxide',
			-- Browse synonyms for a word
			'rafi/telescope-thesaurus.nvim',
		},
		-- stylua: ignore
		keys = {
			-- General pickers
			{ '<localleader>r', '<cmd>Telescope resume<CR>', desc = 'Resume Last' },
			{ '<localleader>p', '<cmd>Telescope pickers<CR>', desc = 'Pickers' },
			{ '<localleader>f', '<cmd>Telescope find_files<CR>', desc = 'Find Files' },
			{ '<localleader>g', '<cmd>Telescope live_grep<CR>', desc = 'Grep' },
			{ '<localleader>b', '<cmd>Telescope buffers<CR>', desc = 'Buffers' },
			{ '<localleader>h', '<cmd>Telescope highlights<CR>', desc = 'Highlights' },
			{ '<localleader>j', '<cmd>Telescope jumplist<CR>', desc = 'Jump List' },
			{ '<localleader>m', '<cmd>Telescope marks<CR>', desc = 'Marks' },
			{ '<localleader>o', '<cmd>Telescope vim_options<CR>', desc = 'Neovim Options' },
			{ '<localleader>t', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', desc = 'Workspace Symbols' },
			{ '<localleader>v', '<cmd>Telescope registers<CR>', desc = 'Registers' },
			{ '<localleader>u', '<cmd>Telescope spell_suggest<CR>', desc = 'Spell Suggest' },
			{ '<localleader>s', "<cmd>lua require'persistence'.select()<CR>", desc = 'Sessions' },
			{ '<localleader>x', '<cmd>Telescope oldfiles<CR>', desc = 'Old Files' },
			{ '<localleader>;', '<cmd>Telescope command_history<CR>', desc = 'Command History' },
			{ '<localleader>:', '<cmd>Telescope commands<CR>', desc = 'Commands' },
			{ '<localleader>/', '<cmd>Telescope search_history<CR>', desc = 'Search History' },
			{ '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', desc = 'Buffer Find' },

			{
				'<leader>,',
				'<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>',
				desc = 'Switch Buffer',
			},
			{ '<leader>ff', '<cmd>Telescope find_files<CR>', desc = 'Find Files' },
			{ '<leader>fg', '<cmd>Telescope live_grep<CR>', desc = 'Grep' },

			{ '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<CR>', desc = 'Document Diagnostics' },
			{ '<leader>sD', '<cmd>Telescope diagnostics<CR>', desc = 'Workspace Diagnostics' },
			{ '<leader>sh', '<cmd>Telescope help_tags<CR>', desc = 'Help Pages' },
			{ '<leader>sk', '<cmd>Telescope keymaps<CR>', desc = 'Key Maps' },
			{ '<leader>sj', '<cmd>Telescope jumplist<cr>', desc = 'Jumplist' },
			{ '<leader>sl', '<cmd>Telescope loclist<cr>', desc = 'Location List' },
			{ '<leader>sm', '<cmd>Telescope man_pages<CR>', desc = 'Man Pages' },
			{ '<leader>sq', '<cmd>Telescope quickfix<cr>', desc = 'Quickfix List' },

			{ '<leader>sw', LazyVim.pick('grep_string', { word_match = '-w' }), desc = 'Word (Root Dir)' },
			{ '<leader>sW', LazyVim.pick('grep_string', { root = false, word_match = '-w' }), desc = 'Word (cwd)' },
			{ '<leader>sw', LazyVim.pick('grep_string'), mode = 'v', desc = 'Selection (Root Dir)' },
			{ '<leader>sW', LazyVim.pick('grep_string', { root = false }), mode = 'v', desc = 'Selection (cwd)' },
			{ '<leader>sc', LazyVim.pick('colorscheme', { enable_preview = true }), desc = 'Colorscheme with Preview' },

			-- LSP related
			{ '<localleader>dd', '<cmd>Telescope lsp_definitions<CR>', desc = 'Definitions' },
			{ '<localleader>di', '<cmd>Telescope lsp_implementations<CR>', desc = 'Implementations' },
			{ '<localleader>dr', '<cmd>Telescope lsp_references<CR>', desc = 'References' },
			{ '<localleader>da', '<cmd>Telescope lsp_code_actions<CR>', desc = 'Code Actions' },
			{ '<localleader>da', ':Telescope lsp_range_code_actions<CR>', mode = 'x', desc = 'Code Actions' },
			{
				'<leader>ss',
				function()
					require('telescope.builtin').lsp_document_symbols({
						symbols = LazyVim.config.get_kind_filter(),
					})
				end,
				desc = 'Goto Symbol',
			},
			{
				'<leader>sS',
				function()
					require('telescope.builtin').lsp_dynamic_workspace_symbols({
						symbols = LazyVim.config.get_kind_filter(),
					})
				end,
				desc = 'Goto Symbol (Workspace)',
			},

			-- Git
			{ '<leader>gs', '<cmd>Telescope git_status<CR>', desc = 'Git Status' },
			{ '<leader>gr', '<cmd>Telescope git_branches<CR>', desc = 'Git Branches' },
			{ '<leader>gL', '<cmd>Telescope git_bcommits<CR>', desc = 'Git Buffer Commits' },
			{ '<leader>gh', '<cmd>Telescope git_stash<CR>', desc = 'Git Stashes' },
			{ '<leader>gc', '<cmd>Telescope git_bcommits_range<CR>', mode = { 'x', 'n' }, desc = 'Git Buffer Commits Range' },

			-- Plugins
			{ '<localleader>n', plugin_directories, desc = 'Plugins' },
			{ '<localleader>k', '<cmd>Telescope thesaurus lookup<CR>', desc = 'Thesaurus' },

			{
				'<localleader>z',
				function()
					require('telescope').extensions.zoxide.list({
						prompt_title = 'Zoxide',
						previewer = false,
						layout_config = { width = 0.6, height = 0.6 },
					})
				end,
				desc = 'Zoxide (MRU)',
			},

			-- Find by...
			{
				'<leader>gf',
				function()
					require('telescope.builtin').find_files({
						default_text = vim.fn.expand('<cword>'),
					})
				end,
				desc = 'Find File',
			},
			{
				'<leader>gg', function()
					require('telescope.builtin').live_grep({
						default_text = vim.fn.expand('<cword>'),
					})
				end,
				desc = 'Grep Cursor Word',
			},
			{
				'<leader>gg',
				function()
					require('telescope.builtin').live_grep({
						default_text = require('rafi.util.edit').get_visual_selection(),
					})
				end,
				mode = 'x',
				desc = 'Grep Cursor Word',
			},

		},
		opts = function(_, opts)
			local actions = require('telescope.actions')
			local transform_mod = require('telescope.actions.mt').transform_mod
			local open_with_trouble = function(...)
				return require('trouble.sources.telescope').open(...)
			end

			local function find_command()
				if 1 == vim.fn.executable('rg') then
					return { 'rg', '--files', '--color', 'never', '--no-ignore-vcs', '--smart-case', '-g', '!.git' }
				elseif 1 == vim.fn.executable('fd') then
					return { 'fd', '--type', 'f', '--color', 'never', '-E', '.git' }
				elseif 1 == vim.fn.executable('fdfind') then
					return { 'fdfind', '--type', 'f', '--color', 'never', '-E', '.git' }
				elseif 1 == vim.fn.executable('find') and vim.fn.has('win32') == 0 then
					return { 'find', '.', '-type', 'f' }
				elseif 1 == vim.fn.executable('where') then
					return { 'where', '/r', '.', '*' }
				end
			end

			-- Transform to Telescope proper actions.
			myactions = transform_mod(myactions)

			-- Clone the default Telescope configuration and enable hidden files.
			local has_ripgrep = vim.fn.executable('rg') == 1
			local vimgrep_args = {
				unpack(require('telescope.config').values.vimgrep_arguments),
			}
			table.insert(vimgrep_args, '--hidden')
			table.insert(vimgrep_args, '--follow')
			table.insert(vimgrep_args, '--no-ignore-vcs')
			table.insert(vimgrep_args, '--glob')
			table.insert(vimgrep_args, '!**/.git/*')

			local path_sep = jit and (jit.os == 'Windows' and '\\' or '/')
				or package.config:sub(1, 1)

			opts = opts or {}
			opts.defaults = {
				sorting_strategy = 'ascending',
				cache_picker = { num_pickers = 3 },

				prompt_prefix = '  ', -- ❯  
				selection_caret = '▍ ',
				multi_icon = ' ',

				path_display = { 'truncate' },
				file_ignore_patterns = { 'node_modules' },
				set_env = { COLORTERM = 'truecolor' },
				vimgrep_arguments = has_ripgrep and vimgrep_args or nil,

				layout_strategy = 'horizontal',
				layout_config = {
					prompt_position = 'top',
					horizontal = {
						height = 0.85,
					},
				},
				history = {
					path = vim.fn.stdpath('state') .. path_sep .. 'telescope_history',
				},

				-- Open files in the first window that is an actual file.
				-- Use the current window if no other window is available.
				get_selection_window = function()
					local wins = vim.api.nvim_list_wins()
					table.insert(wins, 1, vim.api.nvim_get_current_win())
					for _, win in ipairs(wins) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].buftype == '' then
							return win
						end
					end
					return 0
				end,

				-- stylua: ignore
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
						['<C-h>'] = actions.preview_scrolling_left,
						['<C-j>'] = actions.preview_scrolling_down,
						['<C-k>'] = actions.preview_scrolling_up,
						['<C-l>'] = actions.preview_scrolling_right,

						['<c-t>'] = open_with_trouble,
						['<a-t>'] = open_with_trouble,
					},

					n = {
						['q']     = actions.close,
						['<Esc>'] = actions.close,

						['<Tab>'] = actions.move_selection_worse,
						['<S-Tab>'] = actions.move_selection_better,
						['<C-u>'] = myactions.results_scrolling_up,
						['<C-d>'] = myactions.results_scrolling_down,

						['<C-b>'] = actions.preview_scrolling_up,
						['<C-f>'] = actions.preview_scrolling_down,
						['<C-h>'] = actions.preview_scrolling_left,
						['<C-j>'] = actions.preview_scrolling_down,
						['<C-k>'] = actions.preview_scrolling_up,
						['<C-l>'] = actions.preview_scrolling_right,

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

						['t'] = open_with_trouble,

						['p'] = function()
							local entry = require('telescope.actions.state').get_selected_entry()
							require('rafi.util.preview').open(entry.path)
						end,

						-- Compare selected files with diffprg
						['c'] = function(prompt_bufnr)
							if #vim.g.diffprg == 0 then
								LazyVim.error('Set `g:diffprg` to use this feature')
								return
							end
							local from_entry = require('telescope.from_entry')
							local action_state = require('telescope.actions.state')
							local picker = action_state.get_current_picker(prompt_bufnr)
							local entries = {}
							for _, entry in ipairs(picker:get_multi_selection()) do
								table.insert(entries, from_entry.path(entry, false, false))
							end
							if #entries > 0 then
								table.insert(entries, 1, vim.g.diffprg)
								vim.fn.system(entries)
							end
						end,
					},
				},
			}
			opts.pickers = {
				buffers = {
					sort_lastused = true,
					sort_mru = true,
					layout_config = { width = width_large, height = 0.7 },
					mappings = {
						n = {
							['dd'] = actions.delete_buffer,
						},
					},
				},
				find_files = {
					layout_config = { preview_width = 0.5 },
					hidden = true,
					find_command = find_command,
				},
				live_grep = {
					dynamic_preview_title = true,
				},
				colorscheme = {
					enable_preview = true,
					layout_config = { preview_width = 0.7 },
				},
				highlights = {
					layout_config = { preview_width = 0.7 },
				},
				vim_options = {
					theme = 'dropdown',
					layout_config = { width = width_medium, height = 0.7 },
				},
				command_history = {
					theme = 'dropdown',
					layout_config = { width = width_medium, height = 0.7 },
				},
				search_history = {
					theme = 'dropdown',
					layout_config = { width = width_small, height = 0.6 },
				},
				spell_suggest = {
					theme = 'cursor',
					layout_config = { width = width_tiny, height = 0.45 },
				},
				registers = {
					theme = 'cursor',
					layout_config = { width = 0.35, height = 0.4 },
				},
				oldfiles = {
					theme = 'dropdown',
					previewer = false,
					layout_config = { width = width_medium, height = 0.7 },
				},
				lsp_definitions = {
					layout_config = { width = width_large, preview_width = 0.55 },
				},
				lsp_implementations = {
					layout_config = { width = width_large, preview_width = 0.55 },
				},
				lsp_references = {
					layout_config = { width = width_large, preview_width = 0.55 },
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
			}
			opts.extensions = {
				zoxide = {
					prompt_title = '[ Zoxide directories ]',
					mappings = {
						default = {
							action = function(selection)
								vim.cmd.tcd(selection.path)
							end,
							after_action = function(selection)
								vim.notify(
									"Current working directory set to '" .. selection.path .. "'",
									vim.log.levels.INFO
								)
							end,
						},
					},
				},
			}

			return opts
		end,
	},

	-----------------------------------------------------------------------------
	-- Flash Telescope config
	{
		'nvim-telescope/telescope.nvim',
		optional = true,
		opts = function(_, opts)
			if not LazyVim.has('flash.nvim') then
				return
			end
			local function flash(prompt_bufnr)
				require('flash').jump({
					pattern = '^',
					label = { after = { 0, 0 } },
					search = {
						mode = 'search',
						exclude = {
							function(win)
								return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
									~= 'TelescopeResults'
							end,
						},
					},
					action = function(match)
						local picker =
							require('telescope.actions.state').get_current_picker(
								prompt_bufnr
							)
						picker:set_selection(match.pos[1] - 1)
					end,
				})
			end
			opts.defaults = vim.tbl_deep_extend('force', opts.defaults or {}, {
				mappings = { n = { s = flash }, i = { ['<c-s>'] = flash } },
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- better vim.ui with telescope
	{
		'stevearc/dressing.nvim',
		lazy = true,
		enabled = function()
			return LazyVim.pick.want() == 'telescope'
		end,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require('lazy').load({ plugins = { 'dressing.nvim' } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require('lazy').load({ plugins = { 'dressing.nvim' } })
				return vim.ui.input(...)
			end
		end,
	},
}
