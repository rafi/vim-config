-- Rafi's Neovim autocmds
-- https://github.com/rafi/vim-config
-- ===

-- This file is automatically loaded by lua/rafi/config/lazy.lua
-- Extends $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/config/autocmds.lua

vim.api.nvim_del_augroup_by_name('lazyvim_last_loc')
vim.api.nvim_del_augroup_by_name('lazyvim_wrap_spell')

local function augroup(name)
	return vim.api.nvim_create_augroup('rafi.' .. name, { clear = true })
end

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

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('close_with_q'),
	pattern = {
		'blame',
		'fugitive',
		'fugitiveblame',
		'httpResult',
		'lspinfo',
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set('n', 'q', function()
				vim.cmd('close')
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = 'Quit buffer',
			})
		end)
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

-- Spell checking in text file types
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('wrap_spell'),
	pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
	callback = function()
		vim.opt_local.spell = true
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
