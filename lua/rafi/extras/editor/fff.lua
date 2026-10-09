-- Fast fuzzy file finder and live grep with frecency (fff)
local pack = require('rafi.pack')
local root = require('rafi.util.root')

-- Download the prebuilt fff library (or build it with cargo) on install and
-- update, or at startup when target/release has no library yet.
pack.build('fff', {
	build = function()
		require('fff.download').download_or_build_binary()
	end,
	is_built = function(path)
		return vim.fn.glob(path .. '/target/release/*fff_nvim.*') ~= ''
	end,
})

-- Call fff's move up to count times. fff loads the previous page of results on
-- the next tick, leaving the selection in place, so resume the remaining steps
-- once that page is in. Stops at the end of the list.
local function step_list(move, count)
	local state = require('fff.picker_ui.picker_ui').state
	for i = 1, count do
		local cursor, page = state.cursor, state.pagination.page_index
		move()
		if state.cursor == cursor and state.pagination.page_index == page then
			vim.schedule(function()
				if state.active and state.pagination.page_index ~= page then
					step_list(move, count - i)
				end
			end)
			return
		end
	end
end

-- Picker key that moves the selection by a fraction of the results window
-- height (fff only moves one item at a time). Going through fff's own
-- move_down/move_up keeps a bottom prompt and result pages working.
local function scroll_list(direction, fraction)
	return function()
		local ui = require('fff.picker_ui.picker_ui')
		local win = ui.state.list_win
		if not (ui.state.active and win and vim.api.nvim_win_is_valid(win)) then
			return
		end
		local height = vim.api.nvim_win_get_height(win)
		step_list(
			direction > 0 and ui.move_down or ui.move_up,
			math.max(1, math.floor(height * fraction))
		)
	end
end

local opts = vim.g.fff or {}
if type(opts) == 'table' then
	if opts.prompt_vim_mode == nil then
		opts.prompt_vim_mode = true
	end
	if opts.prompt == nil then
		opts.prompt = '> '
	end
	opts.layout = vim.tbl_extend('keep', opts.layout or {}, {
		prompt_position = 'top',
	})
	opts.keymaps = vim.tbl_extend('keep', opts.keymaps or {}, {
		preview_scroll_down = '<C-f>',
		preview_scroll_up = '<C-b>',
	})
	opts.mappings = opts.mappings or {}
	for _, mode in ipairs({ 'i', 'n' }) do
		opts.mappings[mode] = vim.tbl_extend('keep', opts.mappings[mode] or {}, {
			['<C-d>'] = scroll_list(1, 0.5),
			['<C-u>'] = scroll_list(-1, 0.5),
		})
	end
	vim.g.fff = opts
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- Its plugin/ only defines the :FFF* commands. With lazy_sync (default)
	-- indexing starts on the first picker.
	vim.pack.add({ 'https://github.com/dmtrKovalenko/fff' })
end

pack.later(load)

-- Each picker indexes its `cwd` option (default: Neovim's cwd) and re-scans
-- when it differs from the last one, so "Root Dir" and "cwd" keys may scan.

-- NOTE: Conflict: editor.fff wins over snacks' <leader>ff, <leader>fF,
-- <leader>sg and <leader>sw when enabled. editor.telescope maps them too.
-- stylua: ignore start
vim.keymap.set('n', '<leader>ff', function() load() require('fff').find_files({ cwd = root() }) end, { desc = 'Find Files (Root Dir)' })
vim.keymap.set('n', '<leader>fF', function() load() require('fff').find_files() end, { desc = 'Find Files (cwd)' })
vim.keymap.set('n', '<leader>sg', function() load() require('fff').live_grep({ cwd = root() }) end, { desc = 'Grep (Root Dir)' })
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function() load() require('fff').live_grep_under_cursor({ cwd = root() }) end, { desc = 'Visual selection or word (Root Dir)' })
-- stylua: ignore end
