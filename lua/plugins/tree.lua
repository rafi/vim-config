-- plugin: nvim-tree
-- see: https://github.com/kyazdani42/nvim-tree.lua
-- rafi settings
local winwidth = 25

-- :h nvim-tree.lua
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_respect_buf_cwd = 1

vim.g.nvim_tree_git_hl = 0
vim.g.nvim_tree_highlight_opened_files = 0
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_create_in_closed_folder = 0

vim.g.nvim_tree_icon_padding = vim.g.global_symbol_padding or ' '
vim.g.nvim_tree_special_files = {}
vim.g.nvim_tree_show_icons = {
	git = 1, folders = 1, files = 1, folder_arrows = 0 }
vim.g.nvim_tree_icons = {
	default = '',
	symlink = '',
	git = {
		unstaged = '+',
		staged = '+',
		unmerged = '',
		renamed = '',
		untracked = '?',
		deleted = '',
		ignored = '!'
	},
	folder = {
		arrow_open = '',
		arrow_closed = '',
		default = '',
		open = '',
		empty = '',
		empty_open = '',
		symlink = '',
		symlink_open = '',
	}
}

-- Custom actions

local function get_current_directory(node)
	local path = node.absolute_path
	if node.nodes == nil or not node.open then
		local path_separator = package.config:sub(1,1)
		path = path:match('(.*)'..path_separator)
	end
	return path
end

local function grep_tree(node)
	require'telescope.builtin'.live_grep({
		cwd = get_current_directory(node)
	})
end

local function find_tree(node)
	require'telescope.builtin'.find_files({
		cwd = get_current_directory(node)
	})
end

local toggle_width = function(_)
	local max = 0
	local line_count = vim.fn.line('$')

	for i=1, line_count do
		local txt = vim.fn.substitute(vim.fn.getline(i), '\\s\\+$', '', '')
		max = math.max(vim.fn.strdisplaywidth(txt) + 2, max)
	end

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

-- :h nvim-tree
require('nvim-tree').setup({
	hijack_netrw = true,
	hijack_directories = {
		enable = false,
		auto_open = false,
	},

	update_cwd = true,
	open_on_setup = false,

	-- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
	diagnostics = {
		enable = true,
		icons = {
			hint = '',
			info = 'ⁱ',
			warning = '',
			error = '✘',
		}
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 500,
	},
	filters = {
		dotfiles = false,
		custom = {
			'.git', '.hg', '.svc', '.stversions', '.mypy_cache', '.pytest_cache',
			'__pycache__', '.sass-cache', '.DS_Store'
		},
	},
	actions = {
		change_dir = {
			enable = true,
			global = false,
		},
		open_file = {
			quit_on_open = true,
			window_picker = {
				enable = false,
				exclude = {
					filetype = { 'packer', 'qf' },
					buftype = { 'terminal' },
				},
			}
		}
	},
	view = {
		width = winwidth,
		side = 'left',
		signcolumn = 'no',
		mappings = {
			list = {
				-- Edit
				{ key = {'e', 'l'}, action = 'edit' },
				{ key = 'sg',       action = 'vsplit' },
				{ key = 'sv',       action = 'split' },
				{ key = 'st',       action = 'tabnew' },

				-- Navigate
				{ key = '<CR>',     action = 'cd' },
				{ key = '<BS>',     action = 'dir_up' },
				{ key = 'gk',       action = 'first_sibling' },
				{ key = 'gj',       action = 'last_sibling' },
				{ key = '<',        action = 'prev_sibling' },
				{ key = '>',        action = 'next_sibling' },
				{ key = '-',        action = 'parent_node' },
				{ key = 'h',        action = 'close_node' },
				{ key = '[g',       action = 'prev_git_item' },
				{ key = ']g',       action = 'next_git_item' },
				{ key = '<C-r>',    action = 'refresh' },

				-- Search
				{ key = 'gr', action = 'grep_tree', action_cb = grep_tree },
				{ key = 'gf', action = 'find_tree', action_cb = find_tree },

				-- Modify
				{ key = 'N',  action = 'create' },
				{ key = 'dd', action = 'remove' },
				{ key = 'D',  action = 'trash' },
				{ key = 'r',  action = 'rename' },
				{ key = 'R',  action = 'full_rename' },
				{ key = 'x',  action = 'cut' },
				{ key = 'c',  action = 'copy' },
				{ key = 'P',  action = 'paste' },

				-- General
				{ key = 'I',  action = 'toggle_ignored' },
				{ key = '.',  action = 'toggle_dotfiles' },
				{ key = 'g.', action = 'run_file_command' },
				{ key = 'gx', action = 'system_open' },
				{ key = 'g?', action = 'toggle_help' },
				{ key = {'q', '<Esc>'}, action = 'close' },
				{ key = 'w',  action = 'toggle_width', action_cb = toggle_width },

				-- Yank
				{ key = 'y',         action = 'copy_name' },
				{ key = '<Leader>y', action = 'copy_path' },
				{ key = '<Leader>Y', action = 'copy_absolute_path' },
			}
		}
	}
})

-- Cursor hide
--

-- local guicursor_orig = vim.o.guicursor

local function cursor_hide()
	vim.wo.winhighlight = 'CursorLine:WildMenu'
	-- vim.o.guicursor = guicursor_orig .. ',a:TransparentCursor/lCursor'
	vim.wo.cursorline = true
end

local function cursor_restore()
	-- vim.o.guicursor = 'a:Cursor/lCursor'
	-- vim.o.guicursor = guicursor_orig
	vim.wo.cursorline = false
end

-- Attach events on new NvimTree buffer.
local function cursor_attach_events()
	local ok, group_id = pcall(vim.api.nvim_create_augroup, 'nvim-tree-custom', {})
	if not ok then
		return
	end

	vim.api.nvim_create_autocmd('FileType', {
		pattern = 'NvimTree',
		group = group_id,
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()

			-- Hide when entering buffer.
			vim.api.nvim_create_autocmd('BufEnter,WinEnter,CmdwinLeave,CmdlineLeave', {
				buffer = bufnr,
				group = group_id,
				callback = cursor_hide,
			})

			-- Restore when leaving buffer.
			vim.api.nvim_create_autocmd('BufLeave,WinLeave,CmdwinEnter,CmdlineEnter', {
				buffer = bufnr,
				group = group_id,
				callback = cursor_restore,
			})

			-- Restore original cursor when exiting Neovim.
			vim.api.nvim_create_autocmd('VimLeave', {
				buffer = bufnr,
				group = group_id,
				callback = cursor_restore,
			})
		end
	})
end

cursor_attach_events()

-- vim: set ts=2 sw=0 tw=80 noet :
