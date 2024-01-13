-- Rafi's Neovim keymaps
-- github.com/rafi/vim-config
-- ===
-- This file is automatically loaded by rafi.config.init

local RafiUtil = require('rafi.util')
local Util = require('lazyvim.util')
local map = vim.keymap.set

-- Package-manager
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Open Lazy UI' })

-- stylua: ignore start

-- Navigation {{{

-- Moves through display-lines, unless count is provided
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

if vim.g.elite_mode then
	-- Elite-mode: Arrow-keys resize window
	map('n', '<Up>', '<cmd>resize +1<cr>', { desc = 'Increase window height' })
	map('n', '<Down>', '<cmd>resize -1<cr>', { desc = 'Decrease window height' })
	map('n', '<Left>', '<cmd>vertical resize +1<cr>', { desc = 'Increase window width' })
	map('n', '<Right>', '<cmd>vertical resize -1<cr>', { desc = 'Decrease window width' })
else
	-- Moves through display-lines, unless count is provided
	map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
	map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

	-- Resize window using <ctrl> arrow keys
	map('n', '<C-Up>', '<cmd>resize +1<cr>', { desc = 'Increase window height' })
	map('n', '<C-Down>', '<cmd>resize -1<cr>', { desc = 'Decrease window height' })
	map('n', '<C-Right>', '<cmd>vertical resize +1<cr>', { desc = 'Increase window width' })
	map('n', '<C-Left>', '<cmd>vertical resize -1<cr>', { desc = 'Decrease window width' })
end

-- Easier line-wise movement
map('n', 'gh', 'g^', { desc = 'Jump to first screen character' })
map('n', 'gl', 'g$', { desc = 'Jump to last screen character' })

-- Navigation in command line
map('c', '<C-h>', '<Home>')
map('c', '<C-l>', '<End>')
map('c', '<C-f>', '<Right>')
map('c', '<C-b>', '<Left>')

-- Scroll step sideways
map('n', 'zl', 'z4l')
map('n', 'zh', 'z4h')

-- Toggle fold or select option from popup menu
map('n', '<CR>', function()
	return vim.fn.pumvisible() == 1 and '<CR>' or 'za'
end, { expr = true, desc = 'Toggle Fold' })

-- Focus the current fold by closing all others
map('n', '<S-Return>', 'zMzv', { remap = true, desc = 'Focus Fold' })

-- Tabs: Many ways to navigate them
map('n', '<A-j>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<A-k>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
map('n', '<A-[>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
map('n', '<A-]>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<C-Tab>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<C-S-Tab>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })

-- Moving tabs
map('n', '<A-{>', '<cmd>-tabmove<CR>', { desc = 'Tab Move Backwards' })
map('n', '<A-}>', '<cmd>+tabmove<CR>', { desc = 'Tab Move Forwards' })

-- }}}
-- Selection {{{

map('n', '<Leader><Leader>', 'V', { desc = 'Visual Mode' })
map('x', '<Leader><Leader>', '<Esc>', { desc = 'Exit Visual Mode' })

-- Select last paste
map('n', 'gpp', "'`['.strpart(getregtype(), 0, 1).'`]'", { expr = true, desc = 'Select Paste' })

-- Quick substitute within selected area
map('x', 'sg', ':s//gc<Left><Left><Left>', { desc = 'Substitute Within Selection' })

-- C-r: Easier search and replace visual/select mode
map(
	'x',
	'<C-r>',
	":<C-u>%s/\\V<C-R>=v:lua.require'rafi.util.edit'.get_visual_selection()<CR>"
		.. '//gc<Left><Left><Left>',
	{ desc = 'Replace Selection' }
)

-- Re-select blocks after indenting in visual/select mode
map('x', '<', '<gv', { desc = 'Indent Right and Re-select' })
map('x', '>', '>gv|', { desc = 'Indent Left and Re-select' })

-- Use tab for indenting in visual/select mode
map('x', '<Tab>', '>gv|', { desc = 'Indent Left' })
map('x', '<S-Tab>', '<gv', { desc = 'Indent Right' })

-- Better block-wise operations on selected area
local blockwise_force = function(key)
	local c_v = vim.api.nvim_replace_termcodes('<C-v>', true, false, true)
	local keyseq = {
		I  = { v = '<C-v>I',  V = '<C-v>^o^I', [c_v] = 'I' },
		A  = { v = '<C-v>A',  V = '<C-v>0o$A', [c_v] = 'A' },
		gI = { v = '<C-v>0I', V = '<C-v>0o$I', [c_v] = '0I' },
	}
	return function()
		return keyseq[key][vim.fn.mode()]
	end
end
map('x', 'I',  blockwise_force('I'),  { expr = true, noremap = true, desc = 'Blockwise Insert' })
map('x', 'gI', blockwise_force('gI'), { expr = true, noremap = true, desc = 'Blockwise Insert' })
map('x', 'A',  blockwise_force('A'),  { expr = true, noremap = true, desc = 'Blockwise Append' })

-- }}}
-- Jump to {{{

-- map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

map('n', ']q', '<cmd>cnext<CR>', { desc = 'Next Quickfix Item' })
map('n', '[q', '<cmd>cprev<CR>', { desc = 'Previous Quickfix Item' })
map('n', ']a', '<cmd>lnext<CR>', { desc = 'Next Loclist Item' })
map('n', '[a', '<cmd>lprev<CR>', { desc = 'Previous Loclist Item' })

-- Whitespace jump (see plugin/whitespace.vim)
map('n', ']z', function() RafiUtil.edit.whitespace_jump(1) end, { desc = 'Next Whitespace' })
map('n', '[z', function() RafiUtil.edit.whitespace_jump(-1) end, { desc = 'Previous Whitespace' })

-- Diagnostic movement
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	local severity_int = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity_int })
	end
end
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- }}}
-- Clipboard {{{
-- ===

-- Paste in visual-mode without pushing to register
map('x', 'p', 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true, desc = 'Paste' })
map('x', 'P', 'P:let @+=@0<CR>:let @"=@0<CR>', { silent = true, desc = 'Paste In-place' })

-- Yank buffer's relative path to clipboard
map('n', '<Leader>y', function()
	local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.') or ''
	vim.fn.setreg('+', path)
	vim.notify(path, vim.log.levels.INFO, { title = 'Yanked relative path' })
end, { silent = true, desc = 'Yank relative path' })

-- Yank absolute path
map('n', '<Leader>Y', function()
	local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p') or ''
	vim.fn.setreg('+', path)
	vim.notify(path, vim.log.levels.INFO, { title = 'Yanked absolute path' })
end, { silent = true, desc = 'Yank absolute path' })

--- }}}
-- Coding {{{

-- Macros
map('n', '<C-q>', 'q', { desc = 'Macro Prefix' })

-- Formatting
map({ 'n', 'v' }, '<leader>cf', function() Util.format({ force = true }) end, { desc = 'Format' })

-- Start new line from any cursor position in insert-mode
map('i', '<S-Return>', '<C-o>o', { desc = 'Start Newline' })
map('n', ']<Leader>', ':set paste<CR>m`o<Esc>``:set nopaste<CR>', { silent = true, desc = 'Newline' })
map('n', '[<Leader>', ':set paste<CR>m`O<Esc>``:set nopaste<CR>', { silent = true, desc = 'Newline' })

-- Drag current line(s) vertically and auto-indent
map('n', '<Leader>k', '<cmd>move-2<CR>==', { silent = true, desc = 'Move line up' })
map('n', '<Leader>j', '<cmd>move+<CR>==', { silent = true, desc = 'Move line down' })
map('x', '<Leader>k', ":move'<-2<CR>gv=gv", { silent = true, desc = 'Move selection up' })
map('x', '<Leader>j', ":move'>+<CR>gv=gv", { silent = true, desc = 'Move selection down' })

-- Duplicate lines without affecting PRIMARY and CLIPBOARD selections.
map('n', '<Leader>dd', 'm`""Y""P``', { desc = 'Duplicate line' })
map('x', '<Leader>dd', '""Y""Pgv', { desc = 'Duplicate selection' })

-- Duplicate paragraph
map('n', '<Leader>p', 'yap<S-}>p', { desc = 'Duplicate Paragraph' })

-- }}}
-- Search, substitute, diff {{{

-- Switch */g* and #/g#
map('n', '*', 'g*')
map('n', 'g*', '*')
map('n', '#', 'g#')
map('n', 'g#', '#')

-- Clear search with <Esc>
map('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear Search Highlight' })

-- Use backspace key for matching pairs
map({ 'n', 'x' }, '<BS>', '%', { remap = true, desc = 'Jump to Paren' })

-- Toggle diff on all windows in current tab
map('n', '<Leader>bf', function()
	vim.cmd('windo diff' .. (vim.wo.diff and 'off' or 'this'))
end, { desc = 'Diff Windows in Tab' })

-- }}}
-- Command & History {{{

-- Start an external command with a single bang
map('n', '!', ':!', { desc = 'Execute Shell Command' })

-- Put vim command output into buffer
map('n', 'g!', ":put=execute('')<Left><Left>", { desc = 'Paste Command' })

-- Switch history search pairs, matching my bash shell
---@return string
map('c', '<C-p>', function()
	return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
end, { expr = true })

map('c', '<C-n>', function()
	return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
end, { expr = true })

map('c', '<Up>', '<C-p>')
map('c', '<Down>', '<C-n>')

-- Allow misspellings
local cabbrev = vim.cmd.cnoreabbrev
cabbrev('qw', 'wq')
cabbrev('Wq', 'wq')
cabbrev('WQ', 'wq')
cabbrev('Qa', 'qa')
cabbrev('Bd', 'bd')
cabbrev('bD', 'bd')

--- }}}
-- File operations {{{

-- Switch (tab) to the directory of the current opened buffer
map('n', '<Leader>cd', function()
	local bufdir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:h')
	if bufdir ~= nil and vim.loop.fs_stat(bufdir) then
		vim.cmd.tcd(bufdir)
		vim.notify(bufdir)
	end
end, { desc = 'Change Tab Directory' })

-- Fast saving from all modes
map('n', '<Leader>w', '<cmd>write<CR>', { desc = 'Save' })
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = 'Save' })

-- }}}
-- Editor UI {{{

map('n', '<leader>uf', function() Util.format.toggle() end, { desc = 'Toggle auto format (global)' })
map('n', '<leader>uF', function() Util.format.toggle(true) end, { desc = 'Toggle auto format (buffer)' })

-- Toggle editor's visual effects
map('n', '<leader>us', function() Util.toggle('spell') end, { desc = 'Toggle Spelling' })
map('n', '<leader>uw', function() Util.toggle('wrap') end, { desc = 'Toggle Word Wrap' })
map('n', '<leader>uL', function() Util.toggle('relativenumber') end, { desc = 'Toggle Relative Line Numbers' })
map('n', '<leader>ul', function() Util.toggle.number() end, { desc = 'Toggle Line Numbers' })
-- map("n", "<leader>ud", function() Util.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
map('n', '<Leader>uo', '<cmd>setlocal nolist!<CR>', { desc = 'Toggle Whitespace Symbols' })
map('n', '<Leader>uu', '<cmd>nohlsearch<CR>', { desc = 'Hide Search Highlight' })

if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
	map('n', '<leader>uh', function() Util.toggle.inlay_hints() end, { desc = 'Toggle Inlay Hints' })
end

-- Show treesitter nodes under cursor
map('n', '<Leader>ui', vim.show_pos, { desc = 'Show Treesitter Node' })

-- Clear search, diff update and redraw taken from runtime/lua/_editor.lua
map(
	'n',
	'<leader>ur',
	'<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><CR>',
	{ desc = 'Redraw / clear hlsearch / diff update' }
)

-- Smart wrap toggle (breakindent and colorcolumn toggle as-well)
map('n', '<Leader>uw', function()
	vim.opt_local.wrap = not vim.wo.wrap
	vim.opt_local.breakindent = not vim.wo.breakindent

	if vim.wo.colorcolumn == '' then
		vim.opt_local.colorcolumn = tostring(vim.bo.textwidth)
	else
		vim.opt_local.colorcolumn = ''
	end
end, { desc = 'Toggle Wrap' })

-- }}}
-- Plugins & Tools {{{

-- Append mode-line to current buffer
map('n', '<Leader>ml', function() RafiUtil.edit.append_modeline() end, { desc = 'Append Modeline' })

-- Jump entire buffers throughout jumplist
map('n', 'g<C-i>', function() RafiUtil.edit.jump_buffer(1) end, { desc = 'Jump to newer buffer' })
map('n', 'g<C-o>', function() RafiUtil.edit.jump_buffer(-1) end, { desc = 'Jump to older buffer' })

-- Context aware menu. See lua/lib/contextmenu.lua
map('n', '<RightMouse>', function() RafiUtil.contextmenu.show() end)
map('n', '<LocalLeader>c', function() RafiUtil.contextmenu.show() end, { desc = 'Content-aware menu' })

-- Lazygit
map('n', '<leader>tg', function() require('lazy.util').float_term({ 'lazygit' }, { cwd = Util.root(), esc_esc = false }) end, { desc = 'Lazygit (root dir)' })
map('n', '<leader>tG', function() require('lazy.util').float_term({ 'lazygit' }, { esc_esc = false }) end, { desc = 'Lazygit (cwd)' })

-- Terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Enter Normal Mode' })
local lazyterm = function() Util.terminal(nil, { cwd = Util.root() }) end
map('n', '<leader>tt', lazyterm, { desc = 'Terminal (root dir)' })
map('n', '<leader>tT', function() Util.terminal() end, { desc = 'Terminal (cwd)' })

if vim.fn.has('mac') then
	-- Open the macOS dictionary on current word
	map('n', '<Leader>?', '<cmd>silent !open dict://<cword><CR>', { desc = 'Dictionary' })

	-- Use Marked for real-time Markdown preview
	-- See: https://marked2app.com/
	if vim.fn.executable('/Applications/Marked 2.app') then
		vim.api.nvim_create_autocmd('FileType', {
			group = vim.api.nvim_create_augroup('rafi_marked_preview', {}),
			pattern = 'markdown',
			callback = function()
				local cmd = "<cmd>silent !open -a Marked\\ 2.app '%:p'<CR>"
				map('n', '<Leader>P', cmd, { desc = 'Markdown Preview' })
			end,
		})
	end
end

-- }}}
-- Windows and buffers {{{

-- Ultimatus Quitos
if vim.F.if_nil(vim.g.window_q_mapping, true) then
	map('n', 'q', function()
		local plugins = {
			'blame',
			'checkhealth',
			'fugitive',
			'fugitiveblame',
			'help',
			'httpResult',
			'lspinfo',
			'notify',
			'PlenaryTestPopup',
			'qf',
			'query',
			'spectre_panel',
			'startuptime',
			'tsplayground',
		}
		local buf = vim.api.nvim_get_current_buf()
		if vim.tbl_contains(plugins, vim.bo[buf].filetype) then
			vim.bo[buf].buflisted = false
			vim.api.nvim_win_close(0, false)
		else
			-- Find non-floating windows
			local wins = vim.fn.filter(vim.api.nvim_list_wins(), function(_, win)
				if vim.api.nvim_win_get_config(win).zindex then
					return nil
				end
				return win
			end)
			-- If last window, quit
			if #wins > 1 then
				vim.api.nvim_win_close(0, false)
			else
				vim.cmd[[quit]]
			end
		end
	end, { desc = 'Close window' })
end

-- Toggle quickfix window
map('n', '<Leader>q', function() RafiUtil.edit.toggle_list('quickfix') end, { desc = 'Open Quickfix' })

-- Set locations with diagnostics and open the list.
map('n', '<Leader>a', function()
	if vim.bo.filetype ~= 'qf' then
		vim.diagnostic.setloclist({ open = false })
	end
	RafiUtil.edit.toggle_list('loclist')
end, { desc = 'Open Location List' })

-- Switch with adjacent window
map('n', '<C-x>', '<C-w>x<C-w>w', { remap = true, desc = 'Swap adjacent windows' })

map('n', 'sb', '<cmd>buffer#<CR>', { desc = 'Alternate buffer' })
map('n', 'sc', '<cmd>close<CR>', { desc = 'Close window' })
map('n', 'sd', '<cmd>bdelete<CR>', { desc = 'Buffer delete' })
map('n', 'sv', '<cmd>split<CR>', { desc = 'Split window horizontally' })
map('n', 'sg', '<cmd>vsplit<CR>', { desc = 'Split window vertically' })
map('n', 'st', '<cmd>tabnew<CR>', { desc = 'New tab' })
map('n', 'so', '<cmd>only<CR>', { desc = 'Close other windows' })
map('n', 'sq', '<cmd>quit<CR>', { desc = 'Quit' })

-- Background dark/light toggle
map('n', 'sh', function()
	if vim.o.background == 'dark' then
		vim.o.background = 'light'
	else
		vim.o.background = 'dark'
	end
end, { desc = 'Toggle background dark/light' })

-- Empty buffer but leave window
map('n', 'sx', function()
	require('mini.bufremove').delete(0, false)
	vim.cmd.enew()
end, { desc = 'Delete buffer and open new' })

-- Toggle window zoom
map('n', 'sz', function()
	local width = vim.o.columns - 10
	local height = vim.o.lines - 5
	if vim.api.nvim_win_get_width(0) >= width then
		vim.cmd.wincmd('=')
	else
		vim.cmd('vertical resize ' .. width)
		vim.cmd('resize ' .. height)
		vim.cmd('normal! ze')
	end
end, { desc = 'Maximize window' })
-- }}}

-- vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
