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
map('n', '<leader>bd', function()
	Snacks.bufdelete()
end, { desc = 'Delete Buffer' })
map('n', '<leader>bo', function()
	Snacks.bufdelete.other()
end, { desc = 'Delete Other Buffers' })
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
map('n', '<leader>cid', '<cmd>LazyDev<CR>', { silent = true, desc = 'Dev' })
map('n', '<leader>cif', '<cmd>LazyFormatInfo<CR>', { silent = true, desc = 'Formatter Info' })
map('n', '<leader>cir', '<cmd>LazyRoot<CR>', { silent = true, desc = 'Root' })
map('n', '<leader>cil', '<cmd>check lspconfig<cr>', { desc = 'LSP info popup' })
map({ 'n', 'x' }, '<leader>csf', function() Util.edit.formatter_select() end, { desc = 'Formatter Select' })

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

map('n', '<C-c>', 'ciw', { desc = 'Change Inner Word' })

-- Clear search with <Esc>
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear hlsearch' })

-- Use backspace key for matching pairs
map({ 'n', 'x' }, '<BS>', '%', { remap = true, desc = 'Jump to Paren' })

-- Toggle diff on all windows in current tab
map('n', '<Leader>bf', function()
	vim.cmd('windo diff' .. (vim.wo.diff and 'off' or 'this'))
end, { desc = 'Diff Windows in Tab' })

-- External diff
map('n', '<Leader>bF', '<cmd>!' .. vim.g.diffprg .. ' % #<CR>', { desc = 'Diff with' .. vim.g.diffprg })

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
map('n', '<M-s>', '<cmd>write<CR>', { desc = 'Save File' })
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

-- Toggle options
LazyVim.format.snacks_toggle():map('<leader>uf')
LazyVim.format.snacks_toggle(true):map('<leader>uF')
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.line_number():map('<leader>ul')
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' }):map('<leader>uc')
Snacks.toggle.option('showtabline', { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' }):map('<leader>uA')
Snacks.toggle.treesitter():map('<leader>uT')
Snacks.toggle.option('background', { off = 'light', on = 'dark' , name = 'Dark Background' }):map('<leader>ub')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.animate():map('<leader>ua')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.scroll():map('<leader>uS')
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')
if vim.lsp.inlay_hint then
	Snacks.toggle.inlay_hints():map('<leader>uh')
end

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
if vim.fn.executable('lazygit') == 1 then
	map('n', '<leader>gt', function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, { desc = 'Lazygit (Root Dir)' })
	map('n', '<leader>gT', function() Snacks.lazygit() end, { desc = 'Lazygit (cwd)' })
	map('n', '<leader>gF', function() Snacks.lazygit.log_file() end, { desc = 'Lazygit Current File History' })
	map('n', '<leader>gl', function() Snacks.lazygit.log({ cwd = LazyVim.root.git() }) end, { desc = 'Lazygit Log' })
	map('n', '<leader>gL', function() Snacks.lazygit.log() end, { desc = 'Lazygit Log (cwd)' })
end

map('n', '<leader>gm', function() Snacks.git.blame_line() end, { desc = 'Git Blame Line' })
map({ 'n', 'x' }, '<leader>go', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })
map({ 'n', 'x' }, '<leader>gY', function()
	Snacks.gitbrowse({ open = function(url) vim.fn.setreg('+', url) end, notify = false })
end, { desc = 'Git Browse (copy)' })

-- Floating Terminal
map('n', '<Leader>tT', function() Snacks.terminal() end, { desc = 'Terminal (cwd)' })
map('n', '<Leader>tt', function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = 'Terminal (Root Dir)' })
map('n', '<C-/>',      function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = 'Terminal (Root Dir)' })
map('n', '<C-_>',      function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end, { desc = 'which_key_ignore' })

-- Terminal Mappings
map('t', '<C-g>', '<C-\\><C-n>', { desc = 'Enter Normal Mode' })
map('t', '<C-/>', '<cmd>close<CR>', { desc = 'Hide Terminal' })
map('t', '<C-_>', '<cmd>close<CR>', { desc = 'which_key_ignore' })

if vim.fn.has('mac') then
	-- Open the macOS dictionary on current word
	map('n', '<Leader>?', '<cmd>silent !open dict://<cword><CR>', { desc = 'Dictionary' })
end

-- }}}
-- Windows and buffers {{{

-- Quit Neovim
map('n', '<leader>qq', '<cmd>qall<CR>', { desc = 'Exit Neovim' })

-- When enabled, 'q' closes any window.
if vim.F.if_nil(vim.g.window_q_mapping, false) then
	map('n', 'q', function()
		local plugins = {
			'blame',
			'checkhealth',
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
			'PlenaryTestPopup',
			'qf',
			'spectre_panel',
			'startuptime',
			'tsplayground',
		}
		local buf = vim.api.nvim_get_current_buf()
		if vim.tbl_contains(plugins, vim.bo[buf].filetype) then
			vim.bo[buf].buflisted = false
			pcall(vim.api.nvim_buf_delete, buf)
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

-- Switch with adjacent window
map('n', '<C-x>', '<C-w>x<C-w>w', { remap = true, desc = 'Swap adjacent windows' })
map('n', '<C-w>d', '<C-W>c', { desc = 'Delete Window', remap = true })

map('n', 's', '<Nop>')
map('n', 'sb', '<cmd>buffer#<CR>', { desc = 'Alternate buffer' })
map('n', 'sc', '<cmd>close<CR>', { desc = 'Close window' })
map('n', 'sd', '<cmd>bdelete<CR>', { desc = 'Buffer delete' })
map('n', 'sv', '<cmd>split<CR>', { desc = 'Split window horizontally' })
map('n', 'sg', '<cmd>vsplit<CR>', { desc = 'Split window vertically' })
map('n', 'st', '<cmd>tabnew<CR>', { desc = 'New tab' })
map('n', 'so', '<cmd>only<CR>', { desc = 'Close other windows' })
map('n', 'sq', '<cmd>quit<CR>', { desc = 'Quit' })
map('n', 'sx', function()
	Snacks.bufdelete({ wipe = true })
	vim.cmd.enew()
end, { desc = 'Delete buffer and open new' })

Snacks.toggle.zoom():map('sz'):map('<leader>uZ')
Snacks.toggle.zen():map('<leader>uz')
-- }}}

-- Tabs
map('n', '<leader><tab>l', '<cmd>tablast<CR>', { desc = 'Last Tab' })
map('n', '<leader><tab>o', '<cmd>tabonly<CR>', { desc = 'Close Other Tabs' })
map('n', '<leader><tab>f', '<cmd>tabfirst<CR>', { desc = 'First Tab' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<CR>', { desc = 'New Tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<CR>', { desc = 'Close Tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })

-- Native snippets. only needed on < 0.11, as 0.11 creates these by default
if vim.fn.has('nvim-0.11') == 0 then
	map('s', '<Tab>', function()
		return vim.snippet.active({ direction = 1 }) and '<cmd>lua vim.snippet.jump(1)<cr>' or '<Tab>'
	end, { expr = true, desc = 'Jump Next' })
	map({ 'i', 's' }, '<S-Tab>', function()
		return vim.snippet.active({ direction = -1 }) and '<cmd>lua vim.snippet.jump(-1)<cr>' or '<S-Tab>'
	end, { expr = true, desc = 'Jump Previous' })
end

-- vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
