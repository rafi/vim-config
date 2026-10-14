-- Telescope as the picker (replaces snacks picker keys), with fzf-native
-- Loaded on first key or :Telescope. Registers with rafi.util.pick, so
-- generic picks (files, live_grep, oldfiles) open telescope everywhere.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/telescope.lua
local pack = require('rafi.pack')
local pick = require('rafi.util.pick')

-- telescope-fzf-native builds with make or cmake. Skipped without both.
local build_cmd ---@type string?
for _, cmd in ipairs({ 'make', 'cmake', 'gmake' }) do
	if vim.fn.executable(cmd) == 1 then
		build_cmd = cmd
		break
	end
end
local fzf_build = build_cmd
	and (
		build_cmd ~= 'cmake' and 'make'
		or table.concat({
			'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release',
			'cmake --build build --config Release',
			'cmake --install build --prefix build',
		}, ' && ')
	)

-- Build telescope-fzf-native on install and update, or at startup when the
-- library is missing. Registered at startup, so `vim.pack.update()` rebuilds
-- even before telescope is loaded. The build is synchronous, so
-- load_extension('fzf') finds the library.
if fzf_build then
	pack.build('telescope-fzf-native.nvim', {
		build = function(path)
			local res = vim.system({ 'sh', '-c', fzf_build }, { cwd = path }):wait()
			if res.code ~= 0 then
				vim.notify(
					'Building telescope-fzf-native.nvim failed:\n' .. res.stderr,
					vim.log.levels.ERROR
				)
			end
		end,
		is_built = function(path)
			return vim.fn.glob(path .. '/build/libfzf.*') ~= ''
		end,
	})
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

-- Lists vim.pack plugins with a preview of each spec. Selecting one runs
-- :tcd into the plugin directory.
-- Inactive plugins are dimmed.
local function plugin_directories(opts)
	local actions = require('telescope.actions')
	local entry_display = require('telescope.pickers.entry_display')
	local displayer = entry_display.create({ items = { { remaining = true } } })

	require('telescope.pickers')
		.new(opts or {}, {
			layout_config = {
				width = 0.65,
				height = 0.7,
			},
			prompt_title = '[ Plugins ]',
			finder = require('telescope.finders').new_table({
				results = require('rafi.pack').list(),
				---@param plugin vim.pack.PlugData
				entry_maker = function(plugin)
					return {
						value = plugin,
						ordinal = plugin.spec.name,
						path = plugin.path,
						display = function()
							local hl = plugin.active and 'TelescopeResultsNormal'
								or 'TelescopeResultsComment'
							return displayer({ { plugin.spec.name, hl } })
						end,
					}
				end,
			}),
			sorter = require('telescope.config').values.generic_sorter(opts or {}),
			previewer = require('telescope.previewers').new_buffer_previewer({
				title = 'Spec',
				define_preview = function(self, entry)
					local text = vim.inspect(entry.value)
					local buf = self.state.bufnr
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, '\n'))
					require('telescope.previewers.utils').highlighter(buf, 'lua')
				end,
			}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local entry = require('telescope.actions.state').get_selected_entry()
					actions.close(prompt_bufnr)
					if entry then
						vim.cmd.tcd(vim.fn.fnameescape(entry.path))
						vim.notify('Tab directory: ' .. entry.path)
					end
				end)
				return true
			end,
		})
		:find()
end

-- Custom window-sizes

-- Scales `size` by the ratio of the largest `min_cols` threshold it reaches,
-- else by `lower`.
---@param dimensions table<integer|'lower', number>
---@param size integer
---@return number
local function get_matched_ratio(dimensions, size)
	local thresholds = vim.tbl_filter(function(k)
		return k ~= 'lower'
	end, vim.tbl_keys(dimensions))
	table.sort(thresholds, function(a, b)
		return a > b
	end)
	for _, min_cols in ipairs(thresholds) do
		if size >= min_cols then
			return math.floor(size * dimensions[min_cols])
		end
	end
	return math.floor(size * dimensions.lower)
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

local function find_command()
	if 1 == vim.fn.executable('rg') then
		-- stylua: ignore
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

-- Telescope setup options.
-- See telescope.nvim/lua/telescope/config.lua for defaults.
local function telescope_opts()
	local actions = require('telescope.actions')
	local action_state = require('telescope.actions.state')
	local transform_mod = require('telescope.actions.mt').transform_mod
	local open_with_trouble = function(...)
		return require('trouble.sources.telescope').open(...)
	end
	local find_files_no_ignore = function()
		local line = action_state.get_current_line()
		pick('find_files', { no_ignore = true, default_text = line })()
	end
	local find_files_with_hidden = function()
		local line = action_state.get_current_line()
		pick('find_files', { hidden = true, default_text = line })()
	end

	-- Transform to Telescope proper actions.
	local myact = transform_mod(myactions)

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

	local opts = {}
	opts.defaults = {
		sorting_strategy = 'ascending',
		cache_picker = { num_pickers = 3 },

		prompt_prefix = '  ', -- ❯
		selection_caret = '▍ ',
		multi_icon = ' ',

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
			path = vim.fn.stdpath('state') .. '/telescope_history',
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

				['<C-q>'] = myact.smart_send_to_qflist,

				['<C-n>'] = actions.cycle_history_next,
				['<C-p>'] = actions.cycle_history_prev,
				['<C-Down>'] = actions.cycle_history_next,
				['<C-Up>'] = actions.cycle_history_prev,

				['<C-b>'] = actions.preview_scrolling_up,
				['<C-f>'] = actions.preview_scrolling_down,
				['<C-h>'] = actions.preview_scrolling_left,
				['<C-j>'] = actions.preview_scrolling_down,
				['<C-k>'] = actions.preview_scrolling_up,
				['<C-l>'] = actions.preview_scrolling_right,

				['<c-t>'] = open_with_trouble,
				['<a-t>'] = open_with_trouble,
				['<a-i>'] = find_files_no_ignore,
				['<a-h>'] = find_files_with_hidden,
			},

			n = {
				['q']     = actions.close,
				['<Esc>'] = actions.close,

				['<Tab>'] = actions.move_selection_worse,
				['<S-Tab>'] = actions.move_selection_better,
				['<C-u>'] = myact.results_scrolling_up,
				['<C-d>'] = myact.results_scrolling_down,

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

				['w'] = myact.smart_send_to_qflist,
				['e'] = myact.send_to_qflist,

				['!'] = actions.edit_command_line,

				['t'] = open_with_trouble,

				['p'] = function()
					local entry = action_state.get_selected_entry()
					require('rafi.util.preview').open(entry.path)
				end,

				-- Compare selected files with diffprg
				['c'] = function(prompt_bufnr)
					if (vim.g.diffprg or '') == '' then
						vim.notify('Set `g:diffprg` to use this feature', vim.log.levels.ERROR)
						return
					end
					local from_entry = require('telescope.from_entry')
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

	-- Flash jump to a result line. Usually off, since its `s` would shadow
	-- `sv`/`sg`/`st`.
	if pack.has('flash.nvim') then
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
					local picker = action_state.get_current_picker(prompt_bufnr)
					picker:set_selection(match.pos[1] - 1)
				end,
			})
		end
		opts.defaults.mappings.i['<c-s>'] = flash
	end

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
end

-- telescope-thesaurus.nvim: use telescope's picker, unless
-- lua/config/options.lua picked one. dictionaryapi.com, the plugin's
-- default provider, needs a key. Without one, use the free API.
if vim.g.thesaurus == nil then
	vim.g.thesaurus = {
		picker = 'telescope',
		provider = not vim.env.DICTIONARY_API_KEY and 'freedictionaryapi' or nil,
	}
elseif type(vim.g.thesaurus) == 'table' and vim.g.thesaurus.picker == nil then
	vim.g.thesaurus =
		vim.tbl_extend('force', vim.g.thesaurus, { picker = 'telescope' })
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/nvim-lua/plenary.nvim',
		'https://github.com/nvim-telescope/telescope.nvim',
		-- Telescope extension for Zoxide
		'https://github.com/jvgrootveld/telescope-zoxide',
	})
	-- Browse synonyms for a word. editor.thesaurus skips itself when this
	-- extra is on.
	pack.dev(
		'telescope-thesaurus.nvim',
		'https://github.com/rafi/telescope-thesaurus.nvim'
	)

	-- Enable indent-guides in telescope preview
	vim.api.nvim_create_autocmd('User', {
		pattern = 'TelescopePreviewerLoaded',
		group = vim.api.nvim_create_augroup('rafi.telescope', {}),
		callback = function(args)
			if args.buf ~= vim.api.nvim_win_get_buf(0) then
				return
			end
			vim.opt_local.listchars = vim.wo.listchars .. ',tab:▏\\ '
			vim.opt_local.list = true
			vim.opt_local.number = true
		end,
	})

	local telescope = require('telescope')
	telescope.setup(telescope_opts())
	telescope.load_extension('zoxide')

	if fzf_build then
		vim.pack.add({
			'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
		})
		local ok, err = pcall(telescope.load_extension, 'fzf')
		if not ok then
			vim.notify(
				'Failed to load `telescope-fzf-native.nvim`:\n' .. err,
				vim.log.levels.ERROR
			)
		end
	end
end

-- Generic pick names map to telescope builtins. Pickers opened away from
-- cwd get <a-c> to reopen the same search from cwd.
pick.register({
	name = 'telescope',
	commands = {
		files = 'find_files',
	},
	open = function(builtin, opts)
		load()
		opts = opts or {}
		opts.follow = opts.follow ~= false
		if opts.cwd and opts.cwd ~= vim.uv.cwd() then
			local function open_cwd_dir()
				local line = require('telescope.actions.state').get_current_line()
				pick.open(
					builtin,
					vim.tbl_deep_extend('force', {}, opts or {}, {
						root = false,
						cwd = false,
						default_text = line,
					})
				)
			end
			---@diagnostic disable-next-line: inject-field
			opts.attach_mappings = function(_, map)
				-- opts.desc is overridden by telescope, until it's changed there is
				-- this fix
				map('i', '<a-c>', open_cwd_dir, { desc = 'Open cwd Directory' })
				return true
			end
		end
		if opts.cwd == false then
			opts.cwd = nil
		end
		opts.root = nil
		opts.buf = nil
		require('telescope.builtin')[builtin](opts)
	end,
})

-- Loads telescope, then runs the real :Telescope (defined by its plugin/).
pack.command('Telescope', load, { desc = 'Telescope', complete = true })

-- LSP keys. These win over the core snacks picker ones.
-- stylua: ignore
require('rafi.util.lang').add({
	keys = {
		['*'] = {
			{ 'gd', function() load() require('telescope.builtin').lsp_definitions({ reuse_win = true }) end, desc = 'Goto Definition', has = 'definition' },
			{ 'gr', '<cmd>Telescope lsp_references<cr>', desc = 'References', nowait = true },
			{ 'gI', function() load() require('telescope.builtin').lsp_implementations({ reuse_win = true }) end, desc = 'Goto Implementation' },
			{ 'gy', function() load() require('telescope.builtin').lsp_type_definitions({ reuse_win = true }) end, desc = 'Goto T[y]pe Definition' },
			{ '<leader>ss', function() load() require('telescope.builtin').lsp_document_symbols({ symbols = require('rafi.util.icons').get_kind_filter() }) end, desc = 'Goto Symbol', has = 'documentSymbol' },
			{ '<leader>sS', function() load() require('telescope.builtin').lsp_dynamic_workspace_symbols({ symbols = require('rafi.util.icons').get_kind_filter() }) end, desc = 'Goto Symbol (Workspace)', has = 'workspace/symbols' },
		},
	},
})

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

-- Keys override the snacks picker ones from plugin/snacks.lua (extras
-- are sourced later). Snacks-only pickers (icons, undo, projects, gh) stay.
-- stylua: ignore start
map('n', '<leader>,', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', 'Switch Buffer')
map('n', '<leader>/', pick('live_grep'), 'Grep (Root Dir)')
map('n', '<leader>:', '<cmd>Telescope command_history<cr>', 'Command History')
-- NOTE: Conflict: rafi.config.keymaps' <leader><space> wins.
-- map('n', '<leader><space>', pick('files'), 'Find Files (Root Dir)')

-- Find
map('n', '<leader>fb', '<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>', 'Buffers')
map('n', '<leader>fB', '<cmd>Telescope buffers<cr>', 'Buffers (all)')
map('n', '<leader>fc', pick.config_files(), 'Find Config File')
map('n', '<leader>ff', pick('files'), 'Find Files (Root Dir)')
map('n', '<leader>fF', pick('files', { root = false }), 'Find Files (cwd)')
map('n', '<leader>fg', '<cmd>Telescope git_files<cr>', 'Find Files (git-files)')
map('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', 'Recent')
map('n', '<leader>fR', pick('oldfiles', { cwd = vim.uv.cwd() }), 'Recent (cwd)')

-- Git
map('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', 'Commits')
-- NOTE: Conflict: rafi.config.keymaps' <leader>gl (Git Log) wins.
-- map('n', '<leader>gl', '<cmd>Telescope git_commits<CR>', 'Commits')
map('n', '<leader>gs', '<cmd>Telescope git_status<CR>', 'Status')
map('n', '<leader>gS', '<cmd>Telescope git_stash<cr>', 'Git Stash')
-- NOTE: Conflict: rafi.config.keymaps' <leader>gf (Git Current File History) wins.
-- map('n', '<leader>gf', function() load() require('telescope.builtin').find_files({ default_text = vim.fn.expand('<cword>') }) end, 'Find File')

-- Search
map('n', '<leader>s"', '<cmd>Telescope registers<cr>', 'Registers')
map('n', '<leader>s/', '<cmd>Telescope search_history<cr>', 'Search History')
map('n', '<leader>sa', '<cmd>Telescope autocommands<cr>', 'Auto Commands')
map('n', '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', 'Buffer Lines')
map('n', '<leader>sc', '<cmd>Telescope command_history<cr>', 'Command History')
map('n', '<leader>sC', '<cmd>Telescope commands<cr>', 'Commands')
map('n', '<leader>sd', '<cmd>Telescope diagnostics<cr>', 'Diagnostics')
map('n', '<leader>sD', '<cmd>Telescope diagnostics bufnr=0<cr>', 'Buffer Diagnostics')
map('n', '<leader>sg', pick('live_grep'), 'Grep (Root Dir)')
map('n', '<leader>sG', pick('live_grep', { root = false }), 'Grep (cwd)')
map('n', '<leader>sh', '<cmd>Telescope help_tags<cr>', 'Help Pages')
map('n', '<leader>sH', '<cmd>Telescope highlights<cr>', 'Search Highlight Groups')
map('n', '<leader>sj', '<cmd>Telescope jumplist<cr>', 'Jumplist')
map('n', '<leader>sk', '<cmd>Telescope keymaps<cr>', 'Key Maps')
map('n', '<leader>sl', '<cmd>Telescope loclist<cr>', 'Location List')
map('n', '<leader>sM', '<cmd>Telescope man_pages<cr>', 'Man Pages')
map('n', '<leader>sm', '<cmd>Telescope marks<cr>', 'Jump to Mark')
map('n', '<leader>so', '<cmd>Telescope vim_options<cr>', 'Options')
map('n', '<leader>sR', '<cmd>Telescope resume<cr>', 'Resume')
map('n', '<leader>sq', '<cmd>Telescope quickfix<cr>', 'Quickfix List')
map('n', '<leader>sw', pick('grep_string', { word_match = '-w' }), 'Word (Root Dir)')
map('n', '<leader>sW', pick('grep_string', { root = false, word_match = '-w' }), 'Word (cwd)')
map('x', '<leader>sw', pick('grep_string'), 'Selection (Root Dir)')
map('x', '<leader>sW', pick('grep_string', { root = false }), 'Selection (cwd)')

-- UI
map('n', '<leader>uC', pick('colorscheme', { enable_preview = true }), 'Colorscheme with Preview')

-- Rafi
map('n', '<leader>sp', function() load() plugin_directories() end, 'Plugins')
map('n', '<leader><localleader>', '<cmd>Telescope pickers<CR>', 'Pickers')
map('n', '<localleader>u', '<cmd>Telescope spell_suggest<CR>', 'Spell Suggest')
-- NOTE: Conflict: rafi.config.keymaps' <localleader>/ (-> <leader>s/, same
-- picker) wins.
-- map('n', '<localleader>/', '<cmd>Telescope search_history<CR>', 'Search History')
map('n', '<localleader>dd', '<cmd>Telescope lsp_definitions<CR>', 'Definitions')
map('n', '<localleader>di', '<cmd>Telescope lsp_implementations<CR>', 'Implementations')
map('n', '<localleader>dr', '<cmd>Telescope lsp_references<CR>', 'References')
-- lsp_code_actions/lsp_range_code_actions were removed from telescope.
-- map('n', '<localleader>da', '<cmd>Telescope lsp_code_actions<CR>', 'Code Actions')
-- map('x', '<localleader>da', ':Telescope lsp_range_code_actions<CR>', 'Code Actions')
-- The <Plug> map only exists once the plugin is sourced, so load it first.
map('n', '<localleader>k', function() load() vim.api.nvim_feedkeys(vim.keycode('<Plug>(ThesaurusLookup)'), 'm', false) end, 'Thesaurus')
map('n', '<localleader>z', function()
	load()
	require('telescope').extensions.zoxide.list({
		prompt_title = 'Zoxide',
		previewer = false,
		layout_config = { width = 0.6, height = 0.6 },
	})
end, 'Zoxide (MRU)')
-- stylua: ignore end
