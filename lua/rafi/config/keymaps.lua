-- Rafi's Neovim keymaps
-- github.com/rafi/vim-config
-- ===

-- This file is automatically loaded by rafi.config.init

local Util = require('rafi.lib.utils')
local map = vim.keymap.set

local function augroup(name)
	return vim.api.nvim_create_augroup('rafi_' .. name, {})
end

-- Elite-mode: Arrow-keys resize window
if vim.g.rafi_elite_mode then
	map('n', '<Up>', '<cmd>resize +1<cr>', { desc = 'Resize Window' })
	map('n', '<Down>', '<cmd>resize -1<cr>', { desc = 'Resize Window' })
	map('n', '<Left>', '<cmd>vertical resize +1<cr>', { desc = 'Resize Window' })
	map('n', '<Right>', '<cmd>vertical resize -1<cr>', { desc = 'Resize Window' })
end

-- Package-manager
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Open Lazy UI' })

-- stylua: ignore start

-- Navigation
-- ===

-- Moves through display-lines, unless count is provided
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Easier line-wise movement
map('n', 'gh', 'g^')
map('n', 'gl', 'g$')

map('n', '<Leader><Leader>', 'V', { desc = 'Visual Mode' })
map('x', '<Leader><Leader>', '<Esc>', { desc = 'Exit Visual Mode' })

-- Toggle fold or select option from popup menu
---@return string
map('n', '<CR>', function()
	return vim.fn.pumvisible() == 1 and '<CR>' or 'za'
end, { expr = true, desc = 'Toggle Fold' })

-- Focus the current fold by closing all others
map('n', '<S-Return>', 'zMzv', { remap = true, desc = 'Focus Fold' })

-- Location/quickfix list movement
if not Util.has('mini.bracketed') and not Util.has('trouble.nvim') then
	map('n', ']q', '<cmd>cnext<CR>', { desc = 'Next Quickfix Item' })
	map('n', '[q', '<cmd>cprev<CR>', { desc = 'Previous Quickfix Item' })
end
map('n', ']a', '<cmd>lnext<CR>', { desc = 'Next Loclist Item' })
map('n', '[a', '<cmd>lprev<CR>', { desc = 'Previous Loclist Item' })

-- Whitespace jump (see plugin/whitespace.vim)
map('n', ']s', function()
	require('rafi.lib.edit').whitespace_jump(1)
end, { desc = 'Next Whitespace' })
map('n', '[s', function()
	require('rafi.lib.edit').whitespace_jump(-1)
end, { desc = 'Previous Whitespace' })

-- Navigation in command line
map('c', '<C-h>', '<Home>')
map('c', '<C-l>', '<End>')
map('c', '<C-f>', '<Right>')
map('c', '<C-b>', '<Left>')

-- Scroll step sideways
map('n', 'zl', 'z4l')
map('n', 'zh', 'z4h')

-- Clipboard
-- ===

-- Yank buffer's relative path to clipboard
map('n', '<Leader>y', function()
	local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.')
	vim.fn.setreg('+', path)
	vim.notify(path, vim.log.levels.INFO, { title = 'Yanked relative path' })
end, { silent = true, desc = 'Yank relative path' })

-- Yank absolute path
map('n', '<Leader>Y', function()
	local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
	vim.fn.setreg('+', path)
	vim.notify(path, vim.log.levels.INFO, { title = 'Yanked absolute path' })
end, { silent = true, desc = 'Yank absolute path' })

-- Paste in visual-mode without pushing to register
map('x', 'p', 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true, desc = 'Paste' })
map('x', 'P', 'P:let @+=@0<CR>:let @"=@0<CR>', { silent = true, desc = 'Paste In-place' })

-- Edit
-- ===

-- Macros
map('n', '<C-q>', 'q', { desc = 'Macro Prefix' })

-- Start new line from any cursor position in insert-mode
map('i', '<S-Return>', '<C-o>o', { desc = 'Start Newline' })

-- Re-select blocks after indenting in visual/select mode
map('x', '<', '<gv', { desc = 'Indent Right and Re-select' })
map('x', '>', '>gv|', { desc = 'Indent Left and Re-select' })

-- Use tab for indenting in visual/select mode
map('x', '<Tab>', '>gv|', { desc = 'Indent Left' })
map('x', '<S-Tab>', '<gv', { desc = 'Indent Right' })

-- Drag current line/s vertically and auto-indent
map('n', '<Leader>k', '<cmd>move-2<CR>==', { desc = 'Move line up' })
map('n', '<Leader>j', '<cmd>move+<CR>==', { desc = 'Move line down' })
map('x', '<Leader>k', ":move'<-2<CR>gv=gv", { desc = 'Move selection up' })
map('x', '<Leader>j', ":move'>+<CR>gv=gv", { desc = 'Move selection down' })

-- Duplicate lines without affecting PRIMARY and CLIPBOARD selections.
map('n', '<Leader>d', 'm`""Y""P``', { desc = 'Duplicate line' })
map('x', '<Leader>d', '""Y""Pgv', { desc = 'Duplicate selection' })

-- Duplicate paragraph
map('n', '<Leader>cp', 'yap<S-}>p', { desc = 'Duplicate Paragraph' })

-- Remove spaces at the end of lines
map('n', '<Leader>cw', '<cmd>lua MiniTrailspace.trim()<CR>', { desc = 'Erase Whitespace' })

-- Search & Replace
-- ===

-- Switch */g* and #/g#
map('n', '*', 'g*')
map('n', 'g*', '*')
map('n', '#', 'g#')
map('n', 'g#', '#')

-- Clear search with <Esc>
map('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Clear Search Highlight' })

-- Clear search, diff update and redraw taken from runtime/lua/_editor.lua
map(
	'n',
	'<leader>ur',
	'<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><CR>',
	{ desc = 'Redraw / clear hlsearch / diff update' }
)

-- Use backspace key for matching parens
map({ 'n', 'x' }, '<BS>', '%', { remap = true, desc = 'Jump to Paren' })

-- Select last paste
map('n', 'gpp', "'`['.strpart(getregtype(), 0, 1).'`]'", { expr = true, desc = 'Select Paste' })

-- Quick substitute within selected area
map('x', 'sg', ':s//gc<Left><Left><Left>', { desc = 'Substitute Within Selection' })

-- C-r: Easier search and replace visual/select mode
map(
	'x',
	'<C-r>',
	":<C-u>%s/\\V<C-R>=v:lua.require'rafi.lib.edit'.get_visual_selection()<CR>"
		.. '//gc<Left><Left><Left>',
	{ desc = 'Replace Selection' }
)

-- Command & History
-- ===

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
vim.cmd.cnoreabbrev('qw', 'wq')
vim.cmd.cnoreabbrev('Wq', 'wq')
vim.cmd.cnoreabbrev('WQ', 'wq')
vim.cmd.cnoreabbrev('Qa', 'qa')
vim.cmd.cnoreabbrev('Bd', 'bd')
vim.cmd.cnoreabbrev('bD', 'bd')

-- File operations
-- ===

-- Switch (window) to the directory of the current opened buffer
map('n', '<Leader>cd', function()
	local bufdir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:h')
	if bufdir ~= nil and vim.loop.fs_stat(bufdir) then
		vim.cmd.tcd(bufdir)
		vim.notify(bufdir)
	end
end, { desc = 'Change Local Directory' })

-- Fast saving from all modes
map('n', '<Leader>w', '<cmd>write<CR>', { desc = 'Save' })
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = 'Save' })

-- Editor UI
-- ===

-- Toggle editor's visual effects
map('n', '<leader>uf', require('rafi.plugins.lsp.format').toggle, { desc = 'Toggle format on Save' })
map('n', '<Leader>us', '<cmd>setlocal spell!<CR>', { desc = 'Toggle Spellcheck' })
map('n', '<Leader>ul', '<cmd>setlocal nonumber!<CR>', { desc = 'Toggle Line Numbers' })
map('n', '<Leader>uo', '<cmd>setlocal nolist!<CR>', { desc = 'Toggle Whitespace Symbols' })
map('n', '<Leader>uu', '<cmd>nohlsearch<CR>', { desc = 'Hide Search Highlight' })

if vim.lsp.inlay_hint then
	map('n', '<leader>uh', function() vim.lsp.inlay_hint(0, nil) end, { desc = 'Toggle Inlay Hints' })
end

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

-- Show treesitter nodes under cursor
-- highlights under cursor
if vim.fn.has('nvim-0.9') == 1 then
	map('n', '<Leader>ui', vim.show_pos, { desc = 'Show Treesitter Node' })
end

-- Custom Tools
-- ===

-- Append mode-line to current buffer
map('n', '<Leader>ml', function()
	require('rafi.lib.edit').append_modeline()
end, { desc = 'Append Modeline' })

-- Jump entire buffers throughout jumplist
map('n', 'g<C-i>', function()
	require('rafi.lib.edit').jump_buffer(1)
end, { desc = 'Jump to newer buffer' })
map('n', 'g<C-o>', function()
	require('rafi.lib.edit').jump_buffer(-1)
end, { desc = 'Jump to older buffer' })

-- Context aware menu. See lua/lib/contextmenu.lua
map('n', '<LocalLeader>c', function()
	require('rafi.lib.contextmenu').show()
end, { desc = 'Content-aware menu' })

-- Lazygit
map('n', '<leader>tg', function() Util.float_term({ 'lazygit' }, { cwd = Util.get_root(), esc_esc = false }) end, { desc = 'Lazygit (root dir)' })
map('n', '<leader>tG', function() Util.float_term({ 'lazygit' }, { esc_esc = false }) end, { desc = 'Lazygit (cwd)' })

-- Floating terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Enter Normal Mode' })
map('n', '<Leader>tt', function() Util.float_term(nil, { cwd = Util.get_root() }) end, { desc = 'Terminal (root dir)' })
map('n', '<Leader>tT', function() Util.float_term() end, { desc = 'Terminal (cwd)' })

if vim.fn.has('mac') then
	-- Open the macOS dictionary on current word
	map('n', '<Leader>?', '<cmd>silent !open dict://<cword><CR>', { desc = 'Dictionary' })

	-- Use Marked for real-time Markdown preview
	-- See: https://marked2app.com/
	if vim.fn.executable('/Applications/Marked 2.app') then
		vim.api.nvim_create_autocmd('FileType', {
			group = augroup('marked_preview'),
			pattern = 'markdown',
			callback = function()
				local cmd = "<cmd>silent !open -a Marked\\ 2.app '%:p'<CR>"
				map('n', '<Leader>P', cmd, { desc = 'Markdown Preview' })
			end,
		})
	end
end

-- Windows, buffers and tabs
-- ===

-- Ultimatus Quitos
if vim.F.if_nil(vim.g.rafi_window_q_mapping, true) then
	vim.api.nvim_create_autocmd({ 'BufWinEnter', 'VimEnter' }, {
		group = augroup('quit_mapping'),
		callback = function(event)
			if vim.bo.buftype == '' and vim.fn.maparg('q', 'n') == '' then
				local args = { buffer = event.buf, desc = 'Quit' }
				map('n', 'q', '<cmd>quit<CR>', args)
			end
		end,
	})
end

-- Toggle quickfix window
map('n', '<Leader>q', function()
	require('rafi.lib.edit').toggle_list('quickfix')
end, { desc = 'Open Quickfix' })

-- Set locations with diagnostics and open the list.
map('n', '<Leader>a', function()
	if vim.bo.filetype ~= 'qf' then
		vim.diagnostic.setloclist({ open = false })
	end
	require('rafi.lib.edit').toggle_list('loclist')
end, { desc = 'Open Location List' })

-- Switch with adjacent window
map('n', '<C-x>', '<C-w>x', { remap = true, desc = 'Swap windows' })

map('n', 'sb', '<cmd>buffer#<CR>', { desc = 'Alternate buffer' })
map('n', 'sc', '<cmd>close<CR>', { desc = 'Close window' })
map('n', 'sd', '<cmd>bdelete<CR>', { desc = 'Buffer delete' })
map('n', 'sv', '<cmd>split<CR>', { desc = 'Split window horizontally' })
map('n', 'sg', '<cmd>vsplit<CR>', { desc = 'Split window vertically' })
map('n', 'st', '<cmd>tabnew<CR>', { desc = 'New tab' })
map('n', 'so', '<cmd>only<CR>', { desc = 'Close other windows' })
map('n', 'sq', '<cmd>quit<CR>', { desc = 'Quit' })
map('n', 'sz', '<cmd>vertical resize | resize | normal! ze<CR>', { desc = 'Maximize' })
map('n', 'sx', function()
	require('mini.bufremove').delete(0, false)
	vim.cmd.enew()
end, { desc = 'Delete buffer and open new' })

-- Background dark/light toggle
map('n', 'sh', function()
	if vim.o.background == 'dark' then
		vim.o.background = 'light'
	else
		vim.o.background = 'dark'
	end
end, { desc = 'Toggle background dark/light' })
