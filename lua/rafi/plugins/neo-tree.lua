-- Plugin: Neo-tree
-- https://github.com/rafi/vim-config

local winwidth = 25

-- Toggle width.
local toggle_width = function()
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
	vim.o.signcolumn = 'auto'
end

-- Find previous neo-tree window and clear bright highlight selection.
-- Don't hide cursorline though, so 'follow_current_file' works.
local function reset_cursorline()
	local winid = vim.fn.win_getid(vim.fn.winnr('#'))
	vim.api.nvim_win_set_option(winid, 'winhighlight', '')
end

return {

	-----------------------------------------------------------------------------
	'nvim-neo-tree/neo-tree.nvim',
	dependencies = {
		'MunifTanjim/nui.nvim',
		's1n7ax/nvim-window-picker',
	},
	cmd = 'Neotree',
	keys = {
		{
			'<LocalLeader>e',
			'<cmd>Neotree filesystem left toggle dir=./<CR>',
			desc = 'Explorer NeoTree Toggle',
		},
		{
			'<LocalLeader>a',
			'<cmd>Neotree filesystem left reveal dir=./<CR>',
			desc = 'Explorer NeoTree Reveal',
		},
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		vim.g.neo_tree_remove_legacy_commands = 1
		if vim.fn.argc() == 1 then
			local stat = vim.loop.fs_stat(tostring(vim.fn.argv(0)))
			if stat and stat.type == 'directory' then
				require('neo-tree')
			end
		end
	end,
	-- See: https://github.com/nvim-neo-tree/neo-tree.nvim
	opts = {
		close_if_last_window = true,
		popup_border_style = 'rounded',

		source_selector = {
			winbar = false,     -- toggle to show selector on winbar
			statusline = false, -- toggle to show selector on statusline
			show_scrolled_off_parent_node = true,
		},

		event_handlers = {
			-- Close neo-tree when opening a file.
			{
				event = 'file_opened',
				handler = function()
					require('neo-tree').close_all()
				end,
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
				['?'] = 'noop',
				['/'] = 'noop',

				['g?'] = 'show_help',
				['<2-LeftMouse>'] = 'open',
				['<CR>'] = 'split_with_window_picker',
				['l'] = 'open_drop',
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
				['A'] = 'noop',
				['N'] = { 'add_directory', config = { show_path = 'relative' }},
				['d'] = 'noop',
				['dd'] = 'delete',
				['r'] = 'rename',
				['y'] = 'copy_to_clipboard',
				['x'] = 'cut_to_clipboard',
				['P'] = 'paste_from_clipboard',

				['<Space>'] = {
					'toggle_preview',
					nowait = true,
					config = { use_float = true },
				},

				['w'] = toggle_width,
				['p'] = function(state)
					local path = state.tree:get_node().path
					require('rafi.lib.preview').open(path)
				end,
			},
		},
		filesystem = {
			window = {
				mappings = {
					['H'] = 'toggle_hidden',
					['f'] = 'fuzzy_finder',
					['/'] = 'filter_on_submit',
					['<C-x>'] = 'clear_filter',
					['<C-c>'] = 'clear_filter',
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
			follow_current_file = true,
			group_empty_dirs = true,
			bind_to_cwd = false,
			cwd_target = {
				sidebar = 'window',
				current = 'window'
			},

			filtered_items = {
				visible = false,
				show_hidden_count = true,
				hide_dotfiles = false,
				hide_gitignored = true,
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
	}
}
