-- Rafi's Neovim autocmds
-- https://github.com/rafi/vim-config
-- ===
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- This file is automatically loaded by rafi.config.setup() (init.lua)

local function augroup(name)
	return vim.api.nvim_create_augroup('rafi.' .. name, { clear = true })
end

-- General autocmds
-- ===

-- Reload the file when it changed outside Neovim
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
	group = augroup('checktime'),
	callback = function()
		if vim.o.buftype ~= 'nofile' then
			vim.cmd('checktime')
		end
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
	group = augroup('highlight_yank'),
	callback = function()
		if vim.fn.has('nvim-0.13') == 1 then
			vim.hl.hl_op()
		else
			---@diagnostic disable-next-line: deprecated
			(vim.hl or vim.highlight).on_yank()
		end
	end,
})

-- Resize splits when the window is resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
	group = augroup('resize_splits'),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd('tabdo wincmd =')
		vim.cmd('tabnext ' .. current_tab)
	end,
})

-- Close some filetypes with <q>. Includes rafi's (blame, fugitive,
-- fugitiveblame, httpResult).
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('close_with_q'),
	pattern = {
		'PlenaryTestPopup',
		'blame',
		'checkhealth',
		'dap-float',
		'dbout',
		'fugitive',
		'fugitiveblame',
		'gitsigns-blame',
		'grug-far',
		'help',
		'httpResult',
		'lspinfo',
		'neotest-output',
		'neotest-output-panel',
		'neotest-summary',
		'notify',
		'qf',
		'spectre_panel',
		'startuptime',
		'tsplayground',
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

-- Make man pages opened inline easier to close
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('man_unlisted'),
	pattern = { 'man' },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})

-- Wrap and check spelling in text filetypes
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('wrap_spell'),
	pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
	group = augroup('json_conceal'),
	pattern = { 'json', 'jsonc', 'json5' },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory
-- does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	group = augroup('auto_create_dir'),
	callback = function(event)
		if event.match:match('^%w%w+:[\\/][\\/]') then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
	end,
})

-- Rafi's autocmds
-- ===

-- Go to last loc when opening a buffer, see ':h last-position-jump'
vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup('last_loc'),
	callback = function(event)
		local exclude = { 'gitcommit', 'commit', 'gitrebase' }
		local buf = event.buf
		if
			vim.tbl_contains(exclude, vim.bo[buf].filetype)
			or vim.b[buf].rafi_last_loc
		then
			return
		end
		vim.b[buf].rafi_last_loc = true
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
		'/dev/shm/*',
		'/private/var/*',
		'/private/tmp/*',
	},
	callback = function()
		vim.opt_local.undolevels = -1 -- Disables undo entirely
		vim.opt_local.undofile = false -- Prevents writing undo history to disk
		vim.opt_local.swapfile = false -- Disables swap file creation
		vim.opt_local.backup = false -- Disables backup file creation
		vim.opt_local.shada = '' -- Prevents history from being saved to ShAda
		vim.opt_local.writebackup = false
		vim.opt_local.shelltemp = false
		vim.opt_local.history = 0
		-- vim.opt_global.backup = false
		-- vim.opt_global.writebackup = false
	end,
})

-- Context-aware popup menu (Overrides $VIMRUNTIME/lua/vim/_defaults.lua)
vim.api.nvim_create_autocmd('MenuPopup', {
	group = augroup('popupmenu'),
	pattern = '*',
	callback = function()
		local cword = vim.fn.expand('<cword>')
		vim.cmd([[
			aunmenu PopUp
			autocmd! nvim.popupmenu

			anoremenu PopUp.Inspect                 <cmd>Inspect<CR>
			anoremenu PopUp.Definition              <cmd>lua vim.lsp.buf.definition()<CR>
			anoremenu PopUp.References              <cmd>lua vim.lsp.buf.references()<CR>
			anoremenu PopUp.Implementation          <cmd>lua vim.lsp.buf.implementation()<CR>
			anoremenu PopUp.Declaration             <cmd>lua vim.lsp.buf.declaration()<CR>
			anoremenu PopUp.-1-                     <Nop>
			anoremenu PopUp.Diagnostics\ (Trouble)  <cmd>Trouble diagnostics<CR>
			anoremenu PopUp.Show\ Diagnostics       <cmd>lua vim.diagnostic.open_float()<CR>
			anoremenu PopUp.Show\ All\ Diagnostics  <cmd>lua vim.diagnostic.setqflist()<CR>
			anoremenu PopUp.Configure\ Diagnostics  <cmd>help vim.diagnostic.config()<CR>
			anoremenu PopUp.-2-                     <Nop>
			anoremenu PopUp.Find\ symbol            <cmd>lua require'telescope.builtin'.lsp_workspace_symbols({default_text = vim.fn.expand('<cword>')})<CR>
			anoremenu PopUp.Grep                    <cmd>lua require('rafi.util.pick')('live_grep', { pattern = vim.fn.expand('<cword>') })()<CR>
			anoremenu PopUp.TODOs                   <cmd>TodoTrouble<CR>
			anoremenu PopUp.Bookmarks               <cmd>lua require'bookmarks'.bookmark_list()<CR>
			anoremenu PopUp.LazyGit                 <cmd>lua Snacks.lazygit()<CR>
			anoremenu PopUp.Open\ Git\ in\ browser  <cmd>lua Snacks.gitbrowse()<CR>
			anoremenu PopUp.Open\ in\ web\ browser  gx
			anoremenu PopUp.-3-                     <Nop>
			vnoremenu PopUp.Cut                     "+x
			vnoremenu PopUp.Copy                    "+y
			anoremenu PopUp.Paste                   "+gP
			vnoremenu PopUp.Paste                   "+P
			vnoremenu PopUp.Delete                  "_x
			nnoremenu PopUp.Select\ All             ggVG
			vnoremenu PopUp.Select\ All             gg0oG$
			inoremenu PopUp.Select\ All             <C-Home><C-O>VG
		]])

		-- LSP
		-- ===

		if
			cword == ''
			or not vim.lsp.get_clients({
				bufnr = 0,
				method = 'textDocument/definition',
			})
		then
			vim.cmd([[amenu disable PopUp.Definition]])
		end
		if
			cword == ''
			or not vim.lsp.get_clients({
				bufnr = 0,
				method = 'textDocument/references',
			})
		then
			vim.cmd([[amenu disable PopUp.References]])
		end
		if
			cword == ''
			or not vim.lsp.get_clients({
				bufnr = 0,
				method = 'textDocument/implementation',
			})
		then
			vim.cmd([[amenu disable PopUp.Implementation]])
		end
		if
			cword == ''
			or not vim.lsp.get_clients({
				bufnr = 0,
				method = 'textDocument/declaration',
			})
		then
			vim.cmd([[amenu disable PopUp.Declaration]])
		end

		-- Plugins
		-- ===

		if cword == '' or not require('rafi.pack').has('telescope.nvim') then
			vim.cmd([[amenu disable PopUp.Find\ symbol]])
		end
		if cword == '' then
			vim.cmd([[amenu disable PopUp.Grep]])
		end
		if not require('rafi.pack').has('trouble.nvim') then
			vim.cmd([[amenu disable PopUp.Diagnostics\ (Trouble)]])
		end
		if not require('rafi.pack').has('todo-comments.nvim') then
			vim.cmd([[amenu disable PopUp.TODOs]])
		end
		if not require('rafi.pack').has('bookmarks.nvim') then
			vim.cmd([[amenu disable PopUp.Bookmarks]])
		end
		if not _G.Snacks then
			vim.cmd([[
				amenu disable PopUp.LazyGit
				amenu disable PopUp.Open\ Git\ in\ browser
			]])
		end
	end,
})
