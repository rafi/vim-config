-- Rafi's autocmds
-- github.com/rafi/vim-config
-- ===

local function augroup(name)
	return vim.api.nvim_create_augroup('rafi_' .. name, {})
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
	group = augroup('checktime'),
	command = 'checktime',
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup('last_loc'),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Show cursor line only in active window
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
	group = augroup('auto_cursorline_show'),
	callback = function()
		if vim.api.nvim_buf_get_option(0, 'buftype') == '' then
			vim.wo.cursorline = true
		end
	end,
})
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
	group = augroup('auto_cursorline_hide'),
	callback = function()
		if vim.api.nvim_buf_get_option(0, 'buftype') == '' then
			vim.wo.cursorline = false
		end
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
	group = augroup('highlight_yank'),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Automatically set read-only for files being edited elsewhere
vim.api.nvim_create_autocmd('SwapExists', {
	group = augroup('open_swap'),
	nested = true,
	callback = function()
		vim.v.swapchoice = 'o'
	end,
})

-- Create directories when needed, when saving a file (except for URIs "://").
vim.api.nvim_create_autocmd('BufWritePre', {
	group = augroup('auto_create_dir'),
	callback = function(event)
		if not event.match:match('^[a-z]+://') then
			local file = vim.loop.fs_realpath(event.match) or event.match
			vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
		end
	end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
	group = augroup('resize_splits'),
	callback = function()
		vim.cmd('wincmd =')
	end,
})

-- Wrap and enable spell-checker in text filetypes
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('wrap_spell'),
	pattern = { 'gitcommit', 'markdown' },
	callback = function()
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
	group = augroup('undo_disable'),
	pattern = { '/tmp/*', '*.tmp', '*.bak', 'COMMIT_EDITMSG', 'MERGE_MSG' },
	callback = function(event)
		vim.opt_local.undofile = false
		if event.file == 'COMMIT_EDITMSG' or event.file == 'MERGE_MSG' then
			vim.opt_local.swapfile = false
		end
	end,
})

-- Disable swap/undo/backup files in temp directories or shm
vim.api.nvim_create_autocmd({'BufNewFile', 'BufReadPre'}, {
	group = augroup('secure'),
	pattern = {
		'/tmp/*',
		'$TMPDIR/*',
		'$TMP/*',
		'$TEMP/*',
		'*/shm/*',
		'/private/var/*',
		'.vault.vim',
	},
	callback = function()
		vim.opt_local.undofile = false
		vim.opt_local.swapfile = false
		vim.opt_global.backup = false
		vim.opt_global.writebackup = false
	end,
})

-- Load custom theme overrides once colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
	group = augroup('theme'),
	callback = function()
		local Path = require('plenary.path')
		local current = vim.g['colors_name']
		if current and current ~= 'habamax' then
			local user_theme = Path:new({
				vim.fn.stdpath('config'),
				'themes',
				current .. '.vim',
			})
			if user_theme:exists() then
				vim.fn.execute('source ' .. user_theme:expand())
			end
			-- Save colorscheme
			local cache_file = Path:new({ vim.fn.stdpath('data'), 'theme.txt' })
			cache_file:write(current, 'w', 432)
			cache_file:close()
		end
	end,
})
