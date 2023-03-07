-- plugin: neo-tree
-- see: https://github.com/nvim-neo-tree/neo-tree.nvim
-- rafi settings

local winwidth = 25
vim.g.neo_tree_remove_legacy_commands = 1

-- Toggle width.
local toggle_width = function(_)
	local max = winwidth * 2
	local cur_width = vim.fn.winwidth(0)
	local half = math.floor((winwidth + (max - winwidth) / 2) + 0.5)
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
local function get_current_directory(state)
	local node = state.tree:get_node()
	local path = node.path
	if node.type ~= 'directory' or not node:is_expanded() then
		local path_separator = package.config:sub(1, 1)
		path = path:match('(.*)' .. path_separator)
	end
	return path
end

-- Enable a strong cursorline.
local function set_cursorline()
	vim.wo.winhighlight = 'CursorLine:WildMenu'
	vim.wo.cursorline = true
	vim.o.signcolumn = "auto"
end

-- Find previous neo-tree window and disable its cursorline.
local function reset_cursorline()
	local winid = vim.fn.win_getid(vim.fn.winnr('#'))
	vim.api.nvim_win_set_option(winid, 'cursorline', false)
end

require('neo-tree').setup({
	close_if_last_window = true,
	-- popup_border_style = 'rounded',

	event_handlers = {
		-- Close neo-tree when opening a file.
		{
			event = 'file_opened',
			handler = function() require('neo-tree').close_all() end,
		},
		-- Toggle strong cursorline highlight
		{ event = 'neo_tree_buffer_enter', handler = set_cursorline },
		{ event = 'neo_tree_buffer_leave', handler = reset_cursorline },
	},

	default_component_configs = {
		indent = {
			padding = 0,
		},
		icon = {
			folder_closed = '',
			folder_open = '',
			folder_empty = '',
			default = '',
		},
		modified = {
			symbol = '•',
		},
		name = {
			trailing_slash = true,
			use_git_status_colors = false,
		},
		git_status = {
			align = 'right',
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
		position = 'left',
		width = winwidth,
		mappings = {
			['q'] = 'close_window',
			['<Space>'] = { 'toggle_node', nowait = true },
			['?'] = 'none',

			['g?'] = 'show_help',
			['<2-LeftMouse>'] = 'open',
			['<CR>'] = 'open',
			['l'] = 'open',
			['h'] = 'close_node',
			['C'] = 'close_node',
			['z'] = 'close_all_nodes',
			['<C-r>'] = 'refresh',

			['sv'] = 'open_split',
			['sg'] = 'open_vsplit',
			['st'] = 'open_tabnew',

			['c'] = { 'copy', config = { show_path = 'relative' }},
			['m'] = { 'move', config = { show_path = 'relative' }},
			['a'] = { 'add', nowait = true, config = { show_path = 'relative' }},
			['A'] = 'none',
			['N'] = { 'add_directory', config = { show_path = 'relative' }},
			['d'] = 'none',
			['dd'] = 'delete',
			['r'] = 'rename',
			['y'] = 'copy_to_clipboard',
			['x'] = 'cut_to_clipboard',
			['P'] = 'paste_from_clipboard',

			['w'] = toggle_width,
		},
	},
	filesystem = {
		window = {
			mappings = {
				['H'] = 'toggle_hidden',
				['/'] = 'fuzzy_finder',
				['f'] = 'filter_on_submit',
				['<C-x>'] = 'clear_filter',
				['<BS>'] = 'navigate_up',
				['.'] = 'set_root',
				['[g'] = 'prev_git_modified',
				[']g'] = 'next_git_modified',

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
		use_libuv_file_watcher = true,
		follow_current_file = false,
		group_empty_dirs = true,
		bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
		-- The renderer section provides the renderers that will be used to render the tree.
		-- The first level is the node type.
		-- For each node type, you can specify a list of components to render.
		-- Components are rendered in the order they are specified.
		-- The first field in each component is the name of the function to call.
		-- The rest of the fields are passed to the function as the "config" argument.
		filtered_items = {
			visible = false, -- when true, they will just be displayed differently than normal items
			show_hidden_count = false,
			hide_dotfiles = false,
			hide_gitignored = false,
			hide_by_name = {
				'.git',
				'.hg',
				'.svc',
				'.stversions',
				'.mypy_cache',
				'.pytest_cache',
				'__pycache__',
				'.sass-cache',
				'node_modules',
				'.DS_Store',
				'thumbs.db',
			},
			-- remains hidden even if visible is toggled to true
			never_show = {},
		},
	},
	buffers = {
		bind_to_cwd = false,
		follow_current_file = true,
		group_empty_dirs = true,
		window = {
			mappings = {
				['<BS>'] = 'navigate_up',
				['.'] = 'set_root',
				['dd'] = 'buffer_delete',
			},
		},
	},
	git_status = {
		window = {
			mappings = {
				['A'] = 'git_add_all',
				['gu'] = 'git_unstage_file',
				['ga'] = 'git_add_file',
				['gr'] = 'git_revert_file',
				['gc'] = 'git_commit',
				['gp'] = 'git_push',
				['gg'] = 'git_commit_and_push',
			},
		},
	},

})
