-- Rafi's Neovim keymaps
-- github.com/rafi/vim-config
-- ===
-- This file is automatically loaded by rafi.config.init

local Util = require('rafi.util')
local map = vim.keymap.set

-- Package-manager
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Open Lazy UI' })
map('n', '<leader>mx', '<cmd>LazyExtras<CR>', { desc = 'Open Plugin Extras' })

-- stylua: ignore start

-- Navigation {{{

-- Moves through display-lines, unless count is provided
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Down' })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Up' })

if vim.F.if_nil(vim.g.elite_mode, false) then
	-- Elite-mode: Arrow-keys resize window
	map('n', '<Up>', '<cmd>resize +1<cr>', { desc = 'Increase Window Height' })
	map('n', '<Down>', '<cmd>resize -1<cr>', { desc = 'Decrease Window Height' })
	map('n', '<Left>', '<cmd>vertical resize +1<cr>', { desc = 'Increase Window Width' })
	map('n', '<Right>', '<cmd>vertical resize -1<cr>', { desc = 'Decrease Window Width' })
else
	-- Moves through display-lines, unless count is provided
	map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Down' })
	map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Up' })

	-- Resize window using <ctrl> arrow keys
	map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
	map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
	map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
	map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })
end

if not vim.env.TMUX or vim.uv.os_uname().sysname == 'Windows_NT' then
	-- Move to window using the <ctrl> hjkl keys
	map('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window', remap = true })
	map('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window', remap = true })
	map('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window', remap = true })
	map('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window', remap = true })
	-- Terminal Mappings
	map('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to Left Window' })
	map('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to Lower Window' })
	map('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to Upper Window' })
	map('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to Right Window' })
	map('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
	map('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })
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

-- buffers
map('n', '<Leader>bb', '<cmd>e #<CR>', { desc = 'Switch to Other Buffer' })
map('n', '<Leader>`', '<cmd>e #<CR>', { desc = 'Switch to Other Buffer' })
map('n', '<Leader>bd', LazyVim.ui.bufremove, { desc = 'Delete Buffer' })
map('n', '<Leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })

-- }}}
-- Selection {{{

map('n', '<Leader><Leader>', 'V', { desc = 'Visual Mode' })
map('x', '<Leader><Leader>', '<Esc>', { desc = 'Exit Visual Mode' })

-- Select last paste
map('n', 'vsp', "'`['.strpart(getregtype(), 0, 1).'`]'", { expr = true, desc = 'Select Paste' })

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

map('n', '[b', '<cmd>bprev<CR>', { desc = 'Previous Buffer' })
map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next Buffer' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })
map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']a', '<cmd>lnext<CR>', { desc = 'Next Loclist' })
map('n', '[a', '<cmd>lprev<CR>', { desc = 'Previous Loclist' })

-- Whitespace jump (see plugin/whitespace.vim)
map('n', ']z', function() Util.edit.whitespace_jump(1) end, { desc = 'Next Whitespace' })
map('n', '[z', function() Util.edit.whitespace_jump(-1) end, { desc = 'Previous Whitespace' })

-- Diagnostic movement
local diagnostic_jump = function(count, severity)
	local severity_int = severity and vim.diagnostic.severity[severity] or nil
	if vim.fn.has('nvim-0.11') == 1 then
		return function()
			vim.diagnostic.jump({ severity = severity_int, count = count })
		end
	end
	-- Pre 0.11
	---@diagnostic disable-next-line: deprecated
	local jump = count > 0 and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	return function()
		jump({ severity = severity_int })
	end
end
map('n', ']d', diagnostic_jump(1), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_jump(-1), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_jump(1, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_jump(-1, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_jump(1, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_jump(-1, 'WARN'), { desc = 'Prev Warning' })

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

-- Comment
map('n', '<Leader>v', 'gcc', { remap = true, desc = 'Comment Line' })
map('x', '<Leader>v', 'gc', { remap = true, desc = 'Comment Selection' })
map('n', 'gco', 'o<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>', { silent = true, desc = 'Add Comment Below' })
map('n', 'gcO', 'O<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>', { silent = true, desc = 'Add Comment Above' })

-- Macros
map('n', '<C-q>', 'q', { desc = 'Macro Prefix' })

-- Formatting
map({ 'n', 'v' }, '<leader>cf', function() LazyVim.format({ force = true }) end, { desc = 'Format' })
map('n', '<leader>cif', '<cmd>LazyFormatInfo<CR>', { silent = true, desc = 'Formatter Info' })

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

-- }}}
-- Search, substitute, diff {{{

-- Switch */g* and #/g#
map('n', '*', 'g*')
map('n', 'g*', '*')
map('n', '#', 'g#')
map('n', 'g#', '#')

-- Clear search with <Esc>
map('n', '<Esc>', '<cmd>noh<CR>', { desc = 'Escape and Clear hlsearch' })

-- Use backspace key for matching pairs
map({ 'n', 'x' }, '<BS>', '%', { remap = true, desc = 'Jump to Paren' })

-- Toggle diff on all windows in current tab
map('n', '<Leader>bf', function()
	vim.cmd('windo diff' .. (vim.wo.diff and 'off' or 'this'))
end, { desc = 'Diff Windows in Tab' })

-- }}}
-- Command & History {{{

-- Put vim command output into buffer
map('n', 'g!', ":put=execute('')<Left><Left>", { desc = 'Paste Command' })

-- Switch history search pairs, matching my bash shell
map('c', '<Up>', '<C-p>')
map('c', '<Down>', '<C-n>')
map('c', '<C-p>', function()
	return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
end, { expr = true })
map('c', '<C-n>', function()
	return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
end, { expr = true })

-- Use keywordprg
map('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

--- }}}
-- File operations {{{

-- Switch (tab) to the directory of the current opened buffer
map('n', '<Leader>cd', function()
	local bufdir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:h')
	if bufdir ~= nil and vim.uv.fs_stat(bufdir) then
		vim.cmd.tcd(bufdir)
		vim.notify(bufdir)
	end
end, { desc = 'Change Tab Directory' })

-- New file
map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

-- Fast saving from all modes
map('n', '<Leader>w', '<cmd>write<CR>', { desc = 'Save File' })
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = 'Save File' })

-- }}}
-- Editor UI {{{

-- Toggle list windows
map('n', '<leader>xl', function() Util.edit.toggle_list('loclist') end, { desc = 'Toggle Location List' })
map('n', '<leader>xq', function() Util.edit.toggle_list('quickfix') end, { desc = 'Toggle Quickfix List' })

map('n', '<Leader>ce', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Set locations with diagnostics and open the list.
map('n', '<Leader>a', function()
	if vim.bo.filetype ~= 'qf' then
		vim.diagnostic.setloclist({ open = false })
	end
	Util.edit.toggle_list('loclist')
end, { desc = 'Open Location List' })

map('n', '<leader>uf', function() LazyVim.format.toggle() end, { desc = 'Toggle Auto Format (Global)' })
map('n', '<leader>uF', function() LazyVim.format.toggle(true) end, { desc = 'Toggle Auto Format (Buffer)' })
map('n', '<leader>us', function() LazyVim.toggle('spell') end, { desc = 'Toggle Spelling' })
map('n', '<leader>uw', function() LazyVim.toggle('wrap') end, { desc = 'Toggle Word Wrap' })
map('n', '<leader>uL', function() LazyVim.toggle('relativenumber') end, { desc = 'Toggle Relative Line Numbers' })
map('n', '<leader>ul', function() LazyVim.toggle.number() end, { desc = 'Toggle Line Numbers' })
map('n', '<Leader>ud', function() Util.edit.diagnostic_toggle(false) end, { desc = 'Disable Diagnostics' })
map('n', '<Leader>uD', function() Util.edit.diagnostic_toggle(true) end, { desc = 'Disable All Diagnostics' })

map('n', '<Leader>uo', '<cmd>setlocal nolist!<CR>', { desc = 'Toggle Whitespace Symbols' })
map('n', '<Leader>uu', '<cmd>nohlsearch<CR>', { desc = 'Hide Search Highlight' })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map('n', '<leader>uc', function() LazyVim.toggle('conceallevel', false, { 0, conceallevel }) end, { desc = 'Toggle Conceal' })
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
	map('n', '<leader>uh', function() LazyVim.toggle.inlay_hints() end, { desc = 'Toggle Inlay Hints' })
end
map('n', '<leader>uT', function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end, { desc = 'Toggle Treesitter Highlight' })
map('n', '<leader>ub', function() LazyVim.toggle('background', false, {'light', 'dark'}) end, { desc = 'Toggle Background' })

-- Show treesitter nodes under cursor
map('n', '<Leader>ui', vim.show_pos, { desc = 'Show Treesitter Node' })
map('n', '<leader>uI', '<cmd>InspectTree<cr>', { desc = 'Inspect Tree' })

-- Clear search, diff update and redraw taken from runtime/lua/_editor.lua
map(
	'n',
	'<leader>ur',
	'<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><CR>',
	{ desc = 'Redraw / Clear hlsearch / Diff Update' }
)

-- }}}
-- Plugins & Tools {{{

-- Append mode-line to current buffer
map('n', '<Leader>ml', function() Util.edit.append_modeline() end, { desc = 'Append Modeline' })

-- Jump entire buffers throughout jumplist
map('n', 'g<C-i>', function() Util.edit.jump_buffer(1) end, { desc = 'Jump to newer buffer' })
map('n', 'g<C-o>', function() Util.edit.jump_buffer(-1) end, { desc = 'Jump to older buffer' })

-- Context aware menu. See lua/lib/contextmenu.lua
map('n', '<RightMouse>', function() Util.contextmenu.show() end)
map('n', '<LocalLeader>c', function() Util.contextmenu.show() end, { desc = 'Content-aware menu' })

-- Lazygit
map('n', '<leader>tg', function() LazyVim.lazygit( { cwd = LazyVim.root.git() }) end, { desc = 'Lazygit (Root Dir)' })
map('n', '<leader>tG', function() LazyVim.lazygit() end, { desc = 'Lazygit (cwd)' })
map('n', '<leader>tm', LazyVim.lazygit.blame_line, { desc = 'Git Blame Line' })
map('n', '<leader>tf', function()
	local git_path = vim.api.nvim_buf_get_name(0)
	LazyVim.lazygit({args = { '-f', vim.trim(git_path) }})
end, { desc = 'Lazygit Current File History' })

map('n', '<leader>gl', function()
	LazyVim.lazygit({ args = { 'log' }, cwd = LazyVim.root.git() })
end, { desc = 'Lazygit Log' })
map('n', '<leader>gL', function()
	LazyVim.lazygit({ args = { 'log' } })
end, { desc = 'Lazygit Log (cwd)' })

-- Terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Enter Normal Mode' })
local lazyterm = function() LazyVim.terminal(nil, { cwd = LazyVim.root() }) end
map('n', '<leader>tt', lazyterm, { desc = 'Terminal (Root Dir)' })
map('n', '<leader>tT', function() LazyVim.terminal() end, { desc = 'Terminal (cwd)' })

if vim.fn.has('mac') then
	-- Open the macOS dictionary on current word
	map('n', '<Leader>?', '<cmd>silent !open dict://<cword><CR>', { desc = 'Dictionary' })
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

map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

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

-- Empty buffer but leave window
map('n', 'sx', function()
	LazyVim.ui.bufremove()
	vim.cmd.enew()
end, { desc = 'Delete buffer and open new' })

-- Toggle window zoom
map('n', 'sz', function() LazyVim.toggle.maximize() end, { desc = 'Maximize Toggle' })
-- }}}

-- vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
