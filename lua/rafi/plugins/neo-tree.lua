-- Plugin: Neo-tree
-- https://github.com/rafi/vim-config

local winwidth = 30

local function toggle_width()
	local max = winwidth * 2
	local cur_width = vim.fn.winwidth(0)
	local half = math.floor((winwidth + (max - winwidth) / 2) + 0.4)
	local new_width = winwidth
	if cur_width == winwidth then
		new_width = half
	elseif cur_width == half then
		new_width = max
	else
		new_width = winwidth
	end
	vim.cmd(new_width .. ' wincmd |')
end

local function get_current_directory(state)
	local node = state.tree:get_node()
	if node.type ~= 'directory' or not node:is_expanded() then
		node = state.tree:get_node(node:get_parent_id())
	end
	return node.path
end

return {

	-----------------------------------------------------------------------------
	-- File explorer written in Lua
	'nvim-neo-tree/neo-tree.nvim',
	branch = 'v3.x',
	dependencies = { 'MunifTanjim/nui.nvim' },
	cmd = 'Neotree',
	-- stylua: ignore
	keys = {
		{
			'<leader>fe',
			function()
				require('neo-tree.command').execute({ toggle = true, dir = LazyVim.root() })
			end,
			desc = 'Explorer NeoTree (Root Dir)',
		},
		{
			'<leader>fE',
			function()
				require('neo-tree.command').execute({ toggle = true, dir = vim.uv.cwd() })
			end,
			desc = 'Explorer NeoTree (cwd)',
		},
		{ '<LocalLeader>e', '<leader>fe', desc = 'Explorer NeoTree (Root Dir)', remap = true },
		{ '<LocalLeader>E', '<leader>fE', desc = 'Explorer NeoTree (cwd)', remap = true },
		{
			'<LocalLeader>a',
			function()
				require('neo-tree.command').execute({
					reveal = true,
					dir = LazyVim.root()
				})
			end,
			desc = 'Explorer NeoTree Reveal',
		},
		{ '<leader>e', '<leader>fe', desc = 'Explorer NeoTree (Root Dir)', remap = true },
		{ '<leader>E', '<leader>fE', desc = 'Explorer NeoTree (cwd)', remap = true },
		{
			'<leader>ge',
			function()
				require('neo-tree.command').execute({ source = 'git_status', toggle = true })
			end,
			desc = 'Git Explorer',
		},
		{
			'<leader>be',
			function()
				require('neo-tree.command').execute({ source = 'buffers', toggle = true })
			end,
			desc = 'Buffer Explorer',
		},
		{
			'<leader>xe',
			function()
				require('neo-tree.command').execute({ source = 'document_symbols', toggle = true })
			end,
			desc = 'Document Explorer',
		},
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
		-- because `cwd` is not set up properly.
		vim.api.nvim_create_autocmd('BufEnter', {
			group = vim.api.nvim_create_augroup(
				'Neotree_start_directory',
				{ clear = true }
			),
			desc = 'Start Neo-tree with directory',
			once = true,
			callback = function()
				if package.loaded['neo-tree'] then
					return
				else
					---@diagnostic disable-next-line: param-type-mismatch
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == 'directory' then
						require('neo-tree')
					end
				end
			end,
		})
	end,
	-- See: https://github.com/nvim-neo-tree/neo-tree.nvim
	opts = {
		close_if_last_window = true,
		sources = { 'filesystem', 'buffers', 'git_status' },
		open_files_do_not_replace_types = {
			'edgy',
			'gitsigns-blame',
			'Outline',
			'qf',
			'terminal',
			'Trouble',
			'trouble',
		},
		popup_border_style = 'rounded',
		sort_case_insensitive = true,

		source_selector = {
			winbar = false,
			show_scrolled_off_parent_node = true,
			padding = { left = 1, right = 0 },
			sources = {
				{ source = 'filesystem', display_name = '  Files' }, --      
				{ source = 'buffers', display_name = '  Buffers' }, --      
				{ source = 'git_status', display_name = ' 󰊢 Git' }, -- 󰊢      
			},
		},

		event_handlers = {
			-- Close neo-tree when opening a file.
			{
				event = 'file_opened',
				handler = function()
					require('neo-tree').close_all()
				end,
			},
		},

		default_component_configs = {
			icon = {
				folder_empty = '',
				folder_empty_open = '',
				default = '',
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
					unstaged = '',
					staged = 'S',
					conflict = 'C',
				},
			},
		},
		window = {
			width = winwidth,
			mappings = {
				['q'] = 'close_window',
				['?'] = 'noop',
				['g?'] = 'show_help',
				['<Space>'] = 'noop',

				-- Close preview or floating neo-tree window, and clear hlsearch.
				['<Esc>'] = function(_)
					require('neo-tree.sources.filesystem.lib.filter_external').cancel()
					require('neo-tree.sources.common.preview').hide()
					vim.cmd([[ nohlsearch ]])
				end,

				['<2-LeftMouse>'] = 'open',
				['<CR>'] = 'open_with_window_picker',
				['l'] = 'open',
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

				['P'] = 'paste_from_clipboard',
				['p'] = {
					'toggle_preview',
					config = { use_float = true },
				},

				-- Custom commands
				['w'] = toggle_width,
				['K'] = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					require('rafi.util').preview.open(path)
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
						require('lazy.util').open(
							state.tree:get_node().path,
							{ system = true }
						)
					end,
					desc = 'Open with System Application',
				},
			},
		},
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			group_empty_dirs = true,
			use_libuv_file_watcher = true,
			window = {
				mappings = {
					['d'] = 'noop',
					['/'] = 'noop',
					['f'] = 'filter_on_submit',
					['F'] = 'fuzzy_finder',
					['<C-c>'] = 'clear_filter',

					-- Custom commands
					['gf'] = function(state)
						require('telescope.builtin').find_files({
							cwd = get_current_directory(state),
						})
					end,
					['gr'] = function(state)
						require('telescope.builtin').live_grep({
							cwd = get_current_directory(state),
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
	},
	config = function(_, opts)
		local function on_move(data)
			Snacks.rename.on_rename_file(data.source, data.destination)
		end

		local events = require('neo-tree.events')
		opts.event_handlers = opts.event_handlers or {}
		vim.list_extend(opts.event_handlers, {
			{ event = events.FILE_MOVED, handler = on_move },
			{ event = events.FILE_RENAMED, handler = on_move },
		})
		require('neo-tree').setup(opts)
		vim.api.nvim_create_autocmd('TermClose', {
			pattern = '*lazygit',
			callback = function()
				if package.loaded['neo-tree.sources.git_status'] then
					require('neo-tree.sources.git_status').refresh()
				end
			end,
		})
	end,
}
