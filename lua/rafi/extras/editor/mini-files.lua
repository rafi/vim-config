-- Column-based file explorer (mini.files)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/mini-files.lua
local opts = {
	windows = {
		preview = true,
		width_focus = 30,
		width_preview = 30,
	},
	options = {
		-- Off, so the snacks explorer or neo-tree still opens directories.
		use_as_default_explorer = false,
	},
}

-- Explorer buffer keys: toggle dotfiles, set cwd, open in a split.
local function setup_buffer_maps()
	local show_dotfiles = true
	local filter_show = function()
		return true
	end
	local filter_hide = function(fs_entry)
		return not vim.startswith(fs_entry.name, '.')
	end

	local toggle_dotfiles = function()
		show_dotfiles = not show_dotfiles
		local new_filter = show_dotfiles and filter_show or filter_hide
		require('mini.files').refresh({ content = { filter = new_filter } })
	end

	-- Opens the entry in a split. With `close_on_file`, closes the explorer
	-- when the entry is a file.
	local map_split = function(buf_id, lhs, direction, close_on_file)
		local rhs = function()
			local new_target_window
			local cur_target_window =
				require('mini.files').get_explorer_state().target_window
			if cur_target_window ~= nil then
				vim.api.nvim_win_call(cur_target_window, function()
					vim.cmd('belowright ' .. direction .. ' split')
					new_target_window = vim.api.nvim_get_current_win()
				end)

				require('mini.files').set_target_window(new_target_window)
				require('mini.files').go_in({ close_on_file = close_on_file })
			end
		end

		local desc = 'Open in ' .. direction .. ' split'
		if close_on_file then
			desc = desc .. ' and close'
		end
		vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
	end

	local files_set_cwd = function()
		local cur_entry_path = require('mini.files').get_fs_entry().path
		local cur_directory = vim.fs.dirname(cur_entry_path)
		if cur_directory ~= nil then
			vim.fn.chdir(cur_directory)
		end
	end

	local group = vim.api.nvim_create_augroup('rafi.mini-files', {})
	vim.api.nvim_create_autocmd('User', {
		group = group,
		pattern = 'MiniFilesBufferCreate',
		callback = function(args)
			local buf_id = args.data.buf_id

			vim.keymap.set(
				'n',
				opts.mappings and opts.mappings.toggle_hidden or 'g.',
				toggle_dotfiles,
				{ buffer = buf_id, desc = 'Toggle hidden files' }
			)

			vim.keymap.set(
				'n',
				opts.mappings and opts.mappings.change_cwd or 'gc',
				files_set_cwd,
				{ buffer = buf_id, desc = 'Set cwd' }
			)

			local m = opts.mappings or {}
			map_split(buf_id, m.go_in_horizontal or '<C-w>s', 'horizontal', false)
			map_split(buf_id, m.go_in_vertical or '<C-w>v', 'vertical', false)
			map_split(buf_id, m.go_in_horizontal_plus or '<C-w>S', 'horizontal', true)
			map_split(buf_id, m.go_in_vertical_plus or '<C-w>V', 'vertical', true)
		end,
	})

	vim.api.nvim_create_autocmd('User', {
		group = group,
		pattern = 'MiniFilesActionRename',
		callback = function(event)
			Snacks.rename.on_rename_file(event.data.from, event.data.to)
		end,
	})
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvim-mini/mini.files' })
	require('mini.files').setup(opts)
	setup_buffer_maps()
end

vim.keymap.set('n', '<leader>fm', function()
	load()
	require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
end, { desc = 'Open mini.files (Directory of Current File)' })

vim.keymap.set('n', '<leader>fM', function()
	load()
	require('mini.files').open(vim.uv.cwd(), true)
end, { desc = 'Open mini.files (cwd)' })
