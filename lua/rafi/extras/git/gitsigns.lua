-- Git signs written in pure lua
-- See: https://github.com/lewis6991/gitsigns.nvim#usage
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua
if vim.fn.executable('git') == 0 then
	return
end

local pack = require('rafi.pack')

---@param buffer integer
local function on_attach(buffer)
	local gs = package.loaded.gitsigns

	local function map(mode, l, r, desc)
		vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
	end

	-- stylua: ignore start
	map('n', ']h', function()
		if vim.wo.diff then
			vim.cmd.normal({ ']c', bang = true })
		else
			gs.nav_hunk('next')
		end
	end, 'Next Hunk')
	map('n', '[h', function()
		if vim.wo.diff then
			vim.cmd.normal({ '[c', bang = true })
		else
			gs.nav_hunk('prev')
		end
	end, 'Prev Hunk')
	map('n', ']H', function() gs.nav_hunk('last') end, 'Last Hunk')
	map('n', '[H', function() gs.nav_hunk('first') end, 'First Hunk')
	map({ 'n', 'x' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
	map({ 'n', 'x' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
	map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
	map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
	map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
	map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview Hunk Inline')
	map('n', '<leader>ghb', function() gs.blame_line({ full = true }) end, 'Blame Line')
	map('n', '<leader>ghB', function() gs.blame() end, 'Blame Buffer')
	map('n', '<leader>ghd', gs.diffthis, 'Diff This')
	map('n', '<leader>ghD', function() gs.diffthis('~') end, 'Diff This ~')
	map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
	-- stylua: ignore end
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- Its plugin/ calls setup() with defaults, then ours re-applies options.
	vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })
	-- stylua: ignore
	require('gitsigns').setup({
		signs = {
			add          = { text = '▎' },
			change       = { text = '▎' },
			delete       = { text = '' },
			topdelete    = { text = '' },
			changedelete = { text = '▎' },
			untracked    = { text = '▎' },
		},
		signs_staged = {
			add          = { text = '▎' },
			change       = { text = '▎' },
			delete       = { text = '' },
			topdelete    = { text = '' },
			changedelete = { text = '▎' },
		},
		signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
		numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
		current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		attach_to_untracked = true,
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		on_attach = on_attach,
	})

	if _G.Snacks then
		Snacks.toggle({
			name = 'Git Signs',
			get = function()
				return require('gitsigns.config').config.signcolumn
			end,
			set = function(state)
				require('gitsigns').toggle_signs(state)
			end,
		}):map('<leader>uG')
	end
end

pack.on_event('BufReadPost,BufNewFile', load)

---@param fn string
local function gs(fn)
	return function()
		load()
		require('gitsigns')[fn]()
	end
end

local function map(lhs, rhs, desc, opts)
	opts = vim.tbl_extend('force', { desc = desc }, opts or {})
	vim.keymap.set('n', lhs, rhs, opts)
end

-- stylua: ignore start
map(']g', ']h', 'Next Hunk', { remap = true })
map('[g', '[h', 'Previous Hunk', { remap = true })
map('gs', gs('preview_hunk'), 'Preview hunk')
map('<leader>gb', gs('blame'), 'Git blame')
map('<leader>ghtb', gs('toggle_current_line_blame'), 'Toggle Git line blame')
map('<leader>ghtd', gs('toggle_deleted'), 'Toggle Git deleted')
map('<leader>ghtw', gs('toggle_word_diff'), 'Toggle Git word diff')
map('<leader>ghtl', gs('toggle_linehl'), 'Toggle Git line highlight')
map('<leader>ghtn', gs('toggle_numhl'), 'Toggle Git number highlight')
map('<leader>ghts', gs('toggle_signs'), 'Toggle Git signs')
-- stylua: ignore end
