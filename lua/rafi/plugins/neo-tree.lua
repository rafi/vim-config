-- Plugin: Neo-tree
-- https://github.com/rafi/vim-config

local winwidth = 30

-- Toggle width.
local toggle_width = function()
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

-- Get current opened directory from state.
---@param state table
---@return string
local function get_current_directory(state)
	local node = state.tree:get_node()
	local path = node.path
	if node.type ~= 'directory' or not node:is_expanded() then
		local path_separator = package.config:sub(1, 1)
		path = path:match('(.*)' .. path_separator)
	end
	return path
end

return {

	-----------------------------------------------------------------------------
	-- File explorer written in Lua
	'nvim-neo-tree/neo-tree.nvim',
	dependencies = {
		'MunifTanjim/nui.nvim',
		's1n7ax/nvim-window-picker',
	},
	cmd = 'Neotree',
	-- stylua: ignore
	keys = {
		{
			'<leader>fe',
			function()
				local Util = require('lazyvim.util')
				require('neo-tree.command').execute({ toggle = true, dir = Util.root() })
			end,
			desc = 'Explorer NeoTree (root dir)',
		},
		{
			'<leader>fE',
			function()
				require('neo-tree.command').execute({ toggle = true, dir = vim.loop.cwd() })
			end,
			desc = 'Explorer NeoTree (cwd)',
		},
		{ '<LocalLeader>e', '<leader>fe', desc = 'Explorer NeoTree (root dir)', remap = true },
		{
			'<LocalLeader>a',
			function()
				local Util = require('lazyvim.util')
				require('neo-tree.command').execute({
					reveal = true,
					dir = Util.root()
				})
			end,
			desc = 'Explorer NeoTree Reveal',
		},
		{ '<leader>e', '<leader>fe', desc = 'Explorer NeoTree (root dir)', remap = true },
		{ '<leader>E', '<leader>fE', desc = 'Explorer NeoTree (cwd)', remap = true },
		{
			'<leader>ge',
			function()
				require('neo-tree.command').execute({ source = 'git_status', toggle = true })
			end,
			desc = 'Git explorer',
		},
		{
			'<leader>be',
			function()
				require('neo-tree.command').execute({ source = 'buffers', toggle = true })
			end,
			desc = 'Buffer explorer',
		},
		{
			'<leader>xe',
			function()
				require('neo-tree.command').execute({ source = 'document_symbols', toggle = true })
			end,
			desc = 'Document explorer',
		},
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		if vim.fn.argc(-1) == 1 then
			local arg = vim.fn.argv(0) --[[@as string]]
			local stat = vim.loop.fs_stat(arg)
			if stat and stat.type == 'directory' then
				require('neo-tree')
			end
		end
	end,
	-- See: https://github.com/nvim-neo-tree/neo-tree.nvim
	opts = {
		close_if_last_window = true,
		sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
		open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'edgy', 'Outline' },
		popup_border_style = 'rounded',
		sort_case_insensitive = true,

		source_selector = {
			winbar = false,
			show_scrolled_off_parent_node = true,
			padding = { left = 1, right = 0 },
			sources = {
				{ source = 'filesystem', display_name = '  Files' },   --       
				{ source = 'buffers',    display_name = '  Buffers' }, --        
				{ source = 'git_status', display_name = ' 󰊢 Git' },     -- 󰊢      
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
				highlight_opened_files = true, -- NeoTreeFileNameOpened
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
				['<Space>'] = 'noop',

				['g?'] = 'show_help',
				['<2-LeftMouse>'] = 'open',
				['<CR>'] = 'open_with_window_picker',
				['l'] = 'open_drop',
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
					nowait = true,
					config = { use_float = true },
				},
				['w'] = toggle_width,
			},
		},
		filesystem = {
			window = {
				mappings = {
					['d'] = 'noop',

					['/'] = 'noop',
					['f'] = 'fuzzy_finder',
					['F'] = 'filter_on_submit',
					['<C-c>'] = 'clear_filter',

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
			bind_to_cwd = false,
			cwd_target = {
				sidebar = 'window',
				current = 'window',
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
				never_show = {},
			},
			group_empty_dirs = true,
			use_libuv_file_watcher = true,
		},
		buffers = {
			bind_to_cwd = false,
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
			require('lazyvim.util').lsp.on_rename(data.source, data.destination)
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
