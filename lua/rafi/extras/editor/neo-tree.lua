-- File explorer tree (replaces the core Snacks explorer)
-- Loads on :Neotree, its keys, or when Neovim starts on a directory.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/neo-tree.lua

local has_git = vim.fn.executable('git') == 1

-- Directory under the cursor: the node itself when it's an open directory,
-- otherwise its parent (for files and closed directories).
local function get_current_directory(state)
	local node = state.tree:get_node()
	if node.type ~= 'directory' or not node:is_expanded() then
		node = state.tree:get_node(node:get_parent_id())
	end
	return node:get_id()
end

---@module 'neo-tree'
---@type neotree.Config
local opts = {
	sources = { 'filesystem', 'buffers', 'git_status' },
	open_files_do_not_replace_types = {
		'terminal',
		'Trouble',
		'trouble',
		'qf',
		'Outline',
	},
	enable_git_status = has_git,
	close_if_last_window = true,
	-- Empty string follows 'winborder'.
	popup_border_style = '',
	sort_case_insensitive = true,

	source_selector = {
		winbar = false,
		show_scrolled_off_parent_node = true,
		padding = { left = 1, right = 0 },
		sources = {
			{ source = 'filesystem', display_name = '  Files' },
			{ source = 'buffers', display_name = '  Buffers' },
			{ source = 'git_status', display_name = ' 󰊢 Git' },
		},
	},

	-- FILE_MOVED/FILE_RENAMED handlers are appended in load().
	event_handlers = {
		-- Close neo-tree when opening a file.
		{
			event = 'file_opened',
			handler = function()
				require('neo-tree.command').execute({ action = 'close' })
			end,
		},
	},

	nesting_rules = {
		['package.json'] = {
			pattern = '^package%.json$',
			files = { 'pnpm-lock%.yaml', 'package-lock%.json', 'yarn%.lock' },
		},
		['go'] = {
			pattern = '(.*)%.go$',
			files = { '%1_test.go' },
		},
		['go.mod'] = {
			pattern = '^go%.mod$',
			files = { 'go%.sum' },
		},
	},

	default_component_configs = {
		indent = {
			with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
			expander_collapsed = '',
			expander_expanded = '',
			expander_highlight = 'NeoTreeExpander',
		},
		icon = {
			folder_empty = '',
			folder_empty_open = '',
			default = '',
		},
		modified = {
			symbol = '•',
		},
		name = {
			trailing_slash = true,
			highlight_opened_files = true,
			use_git_status_colors = false,
		},
		git_status = {
			symbols = {
				-- Change type
				added = 'A',
				deleted = 'D',
				modified = 'M',
				renamed = 'R',
				-- Status type
				untracked = 'U',
				ignored = 'I',
				unstaged = '', -- LazyVim: '󰄱'
				staged = 'S', -- LazyVim: '󰱒'
				conflict = 'C',
			},
		},
	},

	window = {
		width = 30, -- Default 40
		mappings = {
			['q'] = 'close_window',
			['?'] = 'noop',
			['g?'] = 'show_help',
			['<leader>'] = 'noop',
			-- ['<space>'] = 'none', -- LazyVim. Same key as '<leader>' above.

			-- Clear filter, preview and highlight search.
			['<Esc>'] = function(state)
				require('neo-tree.sources.filesystem').reset_search(state, true)
				require('neo-tree.sources.filesystem.lib.filter_external').cancel()
				require('neo-tree.sources.common.preview').hide()
				vim.cmd([[ nohlsearch ]])
			end,

			['<2-LeftMouse>'] = 'open',
			['<CR>'] = 'open_with_window_picker',
			-- Toggle directories instead of opening.
			['l'] = function(state)
				-- Toggle directories or nested items.
				local node = state.tree:get_node()
				if
					node.type == 'directory'
					or (node:has_children() and not node:is_expanded())
				then
					state.commands.toggle_node(state)
				else
					state.commands.open(state)
				end
			end,
			['h'] = 'close_node',
			['C'] = 'close_node',
			['z'] = 'close_all_nodes',
			['<C-r>'] = 'refresh',

			['s'] = 'noop',
			['sv'] = 'open_split',
			['sg'] = 'open_vsplit',
			['st'] = 'open_tabnew',

			['<S-Tab>'] = 'prev_source',
			['<Tab>'] = 'next_source',

			['dd'] = 'delete',
			['c'] = { 'copy', config = { show_path = 'relative' } },
			['m'] = { 'move', config = { show_path = 'relative' } },
			['a'] = { 'add', nowait = true, config = { show_path = 'relative' } },
			['N'] = { 'add_directory', config = { show_path = 'relative' } },

			-- NOTE: Conflict: rafi's paste wins over LazyVim's.
			['P'] = 'paste_from_clipboard',

			['K'] = { 'preview', config = { use_float = true } },
			['p'] = { 'toggle_preview', config = { use_float = true } },

			-- Custom commands

			-- Cycle width: normal → large → small.
			['w'] = function(state)
				local normal = state.window.width
				local large = normal * 1.9
				local small = math.floor(normal / 1.6)
				local cur_width = state.win_width
				local new_width = normal
				if cur_width > normal then
					new_width = small
				elseif cur_width == normal then
					new_width = large
				end
				vim.cmd(new_width .. ' wincmd |')
			end,

			['Y'] = {
				function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					vim.fn.setreg('+', path, 'c')
				end,
				desc = 'Copy Path to Clipboard',
			},

			['O'] = {
				function(state)
					vim.ui.open(state.tree:get_node().path)
				end,
				desc = 'Open with System Application',
			},
		},
	},

	filesystem = {
		bind_to_cwd = false,
		follow_current_file = { enabled = false }, -- LazyVim: true
		find_by_full_path_words = true,
		-- group_empty_dirs = true,
		use_libuv_file_watcher = has_git,
		window = {
			mappings = {
				['d'] = 'noop',
				['/'] = 'noop',
				['f'] = 'filter_on_submit',
				['F'] = 'fuzzy_finder',
				['<C-c>'] = 'clear_filter',

				-- Find file in path.
				['gf'] = function(state)
					require('rafi.util.pick').open(
						'files',
						{ cwd = get_current_directory(state) }
					)
				end,

				-- Live grep in path.
				['gr'] = function(state)
					require('rafi.util.pick').open(
						'live_grep',
						{ cwd = get_current_directory(state) }
					)
				end,

				-- Search and replace in path.
				['gz'] = function(state)
					require('grug-far').open({
						prefills = {
							paths = vim.fn.fnameescape(get_current_directory(state)),
						},
					})
				end,
			},
		},

		filtered_items = {
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_by_name = {
				'.git',
				'.hg',
				'.svc',
				'.DS_Store',
				'thumbs.db',
				'.sass-cache',
				'node_modules',
				'.pytest_cache',
				'.mypy_cache',
				'__pycache__',
				'.stfolder',
				'.stversions',
			},
			never_show_by_pattern = {
				'vite.config.js.timestamp-*',
			},
		},
	},
	buffers = {
		window = {
			mappings = {
				['dd'] = 'buffer_delete',
			},
		},
	},
	git_status = {
		window = {
			mappings = {
				['d'] = 'noop',
				['dd'] = 'delete',
			},
		},
	},
	document_symbols = {
		follow_cursor = true,
		window = {
			mappings = {
				['/'] = 'noop',
				['F'] = 'filter',
			},
		},
	},
}

-- Adds neo-tree and its dependencies, then runs setup. Also wires LSP-aware
-- renames (Snacks.rename) and refreshes git status after lazygit closes.
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/nvim-lua/plenary.nvim',
		'https://github.com/MunifTanjim/nui.nvim',
		{
			src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
			version = 'v3.x',
		},
	})
	-- Same filter rules as the core window picker, for `<CR>`.
	require('rafi.util.window_picker').load()

	local function on_move(data)
		Snacks.rename.on_rename_file(data.source, data.destination)
	end
	local events = require('neo-tree.events')
	vim.list_extend(opts.event_handlers, {
		{ event = events.FILE_MOVED, handler = on_move },
		{ event = events.FILE_RENAMED, handler = on_move },
	})
	require('neo-tree').setup(opts)

	vim.api.nvim_create_autocmd('TermClose', {
		group = vim.api.nvim_create_augroup('rafi.neo-tree', { clear = true }),
		pattern = '*lazygit',
		callback = function()
			if package.loaded['neo-tree.sources.git_status'] then
				require('neo-tree.sources.git_status').refresh()
			end
		end,
	})
end

-- Neovim started on a directory: load neo-tree so it hijacks that buffer.
-- Deferred to BufEnter because cwd isn't set up properly before that.
vim.api.nvim_create_autocmd('BufEnter', {
	group = vim.api.nvim_create_augroup(
		'Neotree_start_directory',
		{ clear = true }
	),
	desc = 'Start Neo-tree with directory',
	once = true,
	callback = function()
		if not loaded then
			local stats = vim.uv.fs_stat(vim.fn.argv(0) --[[@as string]])
			if stats and stats.type == 'directory' then
				load()
			end
		end
	end,
})

-- Stub replaced by the real :Neotree command during setup.
require('rafi.pack').command('Neotree', load, {
	desc = 'Neo-tree file explorer',
	bang = true,
	complete = true,
})

-- Runs a neo-tree command after loading it.
---@param args table
local function execute(args)
	return function()
		load()
		require('neo-tree.command').execute(args)
	end
end

local root = require('rafi.util.root')

local function map(lhs, rhs, desc, extra)
	vim.keymap.set(
		'n',
		lhs,
		rhs,
		vim.tbl_extend('force', { desc = desc }, extra or {})
	)
end

-- Core Snacks skips its explorer and these keys when this extra is on.
-- stylua: ignore start
map('<leader>fe', function() execute({ toggle = true, dir = root() })() end, 'Explorer NeoTree (Root Dir)')
map('<leader>fE', function() execute({ toggle = true, dir = vim.uv.cwd() })() end, 'Explorer NeoTree (cwd)')
map('<leader>e', '<leader>fe', 'Explorer NeoTree (Root Dir)', { remap = true })
map('<leader>E', '<leader>fE', 'Explorer NeoTree (cwd)', { remap = true })
map('<leader>ge', execute({ source = 'git_status', toggle = true }), 'Git Explorer')
map('<leader>be', execute({ source = 'buffers', toggle = true }), 'Buffer Explorer')
map('<localleader>e', '<leader>fe', 'Explorer Tree (Root Dir)', { remap = true })
map('<localleader>E', '<leader>fE', 'Explorer Tree (cwd)', { remap = true })
map('<localleader>a', function() execute({ reveal = true, dir = root() })() end, 'Reveal in Explorer')
map('<localleader>A', function() execute({ reveal = true, dir = vim.uv.cwd() })() end, 'Reveal in Explorer (cwd)')
-- stylua: ignore end
