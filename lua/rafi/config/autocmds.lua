-- Rafi's Neovim autocmds
-- github.com/rafi/vim-config
-- ===

-- This file is automatically loaded by rafi.config.init

local function augroup(name)
	return vim.api.nvim_create_augroup('rafi_' .. name, {})
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
	group = augroup('checktime'),
	command = 'checktime',
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
	group = augroup('highlight_yank'),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
	group = augroup('resize_splits'),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd('tabdo wincmd =')
		vim.cmd('tabnext ' .. current_tab)
	end,
})

-- Go to last loc when opening a buffer, see ':h last-position-jump'
vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup('last_loc'),
	callback = function(event)
		local exclude = { 'gitcommit', 'commit', 'gitrebase' }
		local buf = event.buf
		if
			vim.tbl_contains(exclude, vim.bo[buf].filetype)
			or vim.b[buf].lazyvim_last_loc
		then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Show cursor line only in active window
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
	group = augroup('auto_cursorline_show'),
	callback = function(event)
		if vim.bo[event.buf].buftype == '' then
			vim.opt_local.cursorline = true
		end
	end,
})
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
	group = augroup('auto_cursorline_hide'),
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('wrap_spell'),
	pattern = { 'gitcommit', 'markdown' },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Create directories when needed, when saving a file (except for URIs "://").
vim.api.nvim_create_autocmd('BufWritePre', {
	group = augroup('auto_create_dir'),
	callback = function(event)
		if event.match:match('^%w%w+://') then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
	end,
})

-- Disable swap/undo/backup files in temp directories or shm
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
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
	group = augroup('secure'),
	pattern = {
		'/tmp/*',
		'$TMPDIR/*',
		'$TMP/*',
		'$TEMP/*',
		'*/shm/*',
		'/private/var/*',
	},
	callback = function()
		vim.opt_local.undofile = false
		vim.opt_local.swapfile = false
		vim.opt_global.backup = false
		vim.opt_global.writebackup = false
	end,
})
