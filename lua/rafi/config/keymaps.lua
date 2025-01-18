-- Rafi's Neovim keymaps
-- https://github.com/rafi/vim-config
-- ===
-- This file is automatically loaded by rafi.config.init

local map = vim.keymap.set

-- Package-manager
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Open Lazy UI' })
map('n', '<leader>mx', '<cmd>LazyExtras<cr>', { desc = 'Open Plugin Extras' })

-- stylua: ignore start

-- Picker {{{

-- Bind localleader to common LazyVim picker (telescope/fzf/snacks) keymaps.
map({ 'n', 'x' }, '<localleader>r', '<leader>sR', { remap = true, desc = 'Resume Last' })
map({ 'n', 'x' }, '<localleader>f', '<leader>ff', { remap = true, desc = 'Find Files (Root Dir)' })
map({ 'n', 'x' }, '<localleader>F', '<leader>fF', { remap = true, desc = 'Find Files (cwd)' })
map({ 'n', 'x' }, '<localleader>g', '<leader>sg', { remap = true, desc = 'Grep (Root Dir)' })
map({ 'n', 'x' }, '<localleader>G', '<leader>sG', { remap = true, desc = 'Grep (cwd)' })
map({ 'n', 'x' }, '<localleader>b', '<leader>,',  { remap = true, desc = 'Switch Buffer' })
map({ 'n', 'x' }, '<localleader>h', '<leader>sh',  { remap = true, desc = 'Help Pages' })
map({ 'n', 'x' }, '<localleader>H', '<leader>sH',  { remap = true, desc = 'Search Highlight Groups' })
map({ 'n', 'x' }, '<localleader>j', '<leader>sj',  { remap = true, desc = 'Jumplist' })
map({ 'n', 'x' }, '<localleader>m', '<leader>sm',  { remap = true, desc = 'Jump to Mark' })
map({ 'n', 'x' }, '<localleader>M', '<leader>sM',  { remap = true, desc = 'Man Pages' })
map({ 'n', 'x' }, '<localleader>o', '<leader>so',  { remap = true, desc = 'Options' })
map({ 'n', 'x' }, '<localleader>t', '<leader>ss',  { remap = true, desc = 'Goto Symbol' })
map({ 'n', 'x' }, '<localleader>T', '<leader>sS',  { remap = true, desc = 'Goto Symbol (Workspace)' })
map({ 'n', 'x' }, '<localleader>v', '<leader>s"',  { remap = true, desc = 'Registers' })
map({ 'n', 'x' }, '<localleader>s', '<leader>qS',  { remap = true, desc = 'Sessions' })
map({ 'n', 'x' }, '<localleader>x', '<leader>fr',  { remap = true, desc = 'Recent' })
map({ 'n', 'x' }, '<localleader>X', '<leader>fR',  { remap = true, desc = 'Recent (cwd)' })
map({ 'n', 'x' }, '<localleader>;', '<leader>sc',  { remap = true, desc = 'Command History' })
map({ 'n', 'x' }, '<localleader>:', '<leader>sC',  { remap = true, desc = 'Commands' })
map({ 'n', 'x' }, '<localleader>i', '<leader>sb',  { remap = true, desc = 'Buffer' })
map({ 'n', 'x' }, '<localleader>p', '<leader>qp',  { remap = true, desc = 'Projects' })
map({ 'n', 'x' }, '<leader>gg', '<leader>sw',  { remap = true, desc = 'Visual selection or word (Root Dir)' })
map({ 'n', 'x' }, '<leader>gG', '<leader>sW',  { remap = true, desc = 'Visual selection or word (cwd)' })

-- }}}
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

if not LazyVim.has('vim-tmux-navigator') or vim.uv.os_uname().sysname == 'Windows_NT' then
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
	":<C-u>%s/\\V<C-R>=v:lua.get_visual_selection()<CR>"
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
map('n', ']z', function() whitespace_jump(1) end, { desc = 'Next Whitespace' })
map('n', '[z', function() whitespace_jump(-1) end, { desc = 'Previous Whitespace' })

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

-- }}}
-- Coding {{{

pcall(vim.keymap.del, 'n', 'gra')
pcall(vim.keymap.del, 'n', 'gri')
pcall(vim.keymap.del, 'n', 'grr')
pcall(vim.keymap.del, 'n', 'grn')
pcall(vim.keymap.del, 'n', 'gc')

-- Comment
map('n', '<Leader>v', 'gcc', { remap = true, desc = 'Comment Line' })
map('x', '<Leader>v', 'gc', { remap = true, desc = 'Comment Selection' })
map('n', 'gco', 'o<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>', { silent = true, desc = 'Add Comment Below' })
map('n', 'gcO', 'O<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>', { silent = true, desc = 'Add Comment Above' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- Macros
map('n', '<C-q>', 'q', { desc = 'Macro Prefix' })

-- Formatting
map({ 'n', 'v' }, '<leader>cf', function() LazyVim.format({ force = true }) end, { desc = 'Format' })
map('n', '<leader>cid', '<cmd>LazyDev<CR>', { silent = true, desc = 'Dev' })
map('n', '<leader>cif', '<cmd>LazyFormatInfo<CR>', { silent = true, desc = 'Formatter Info' })
map('n', '<leader>cir', '<cmd>LazyRoot<CR>', { silent = true, desc = 'Root' })
map('n', '<leader>cil', '<cmd>check lspconfig<cr>', { desc = 'LSP info popup' })
map({ 'n', 'x' }, '<leader>cs', function() formatter_select() end, { desc = 'Formatter Select' })

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

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Switch */g* and #/g#
map('n', '*', 'g*')
map('n', 'g*', '*')
map('n', '#', 'g#')
map('n', 'g#', '#')

map('n', '<C-c>', 'ciw', { desc = 'Change Inner Word' })

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

-- }}}
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
map('n', '<leader>xl', function() toggle_list('loclist') end, { desc = 'Toggle Location List' })
map('n', '<leader>xq', function() toggle_list('quickfix') end, { desc = 'Toggle Quickfix List' })

map('n', '<Leader>ce', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Set locations with diagnostics and open the list.
map('n', '<Leader>a', function()
	if vim.bo.filetype ~= 'qf' then
		vim.diagnostic.setloclist({ open = false })
	end
	toggle_list('loclist')
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

-- Clear search and stop snippet on escape
map({ 'i', 'n', 's' }, '<esc>', function()
	vim.cmd("noh")
	LazyVim.cmp.actions.snippet_stop()
	return '<esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })

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
map('n', '<Leader>ml', function() append_modeline() end, { desc = 'Append Modeline' })

-- Jump entire buffers throughout jumplist
map('n', 'g<C-i>', function() jump_buffer(1) end, { desc = 'Jump to newer buffer' })
map('n', 'g<C-o>', function() jump_buffer(-1) end, { desc = 'Jump to older buffer' })

-- Context aware menu. See lua/lib/contextmenu.lua
map('n', '<RightMouse>', function() require('rafi.util.contextmenu').show() end, { desc = 'Context-aware menu' })
map('n', '<LocalLeader>c', function() require('rafi.util.contextmenu').show() end, { desc = 'Context-aware menu' })

-- Lazygit
if vim.fn.executable('lazygit') == 1 then
	---@diagnostic disable-next-line: missing-fields
	map('n', '<leader>gt', function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, { desc = 'Lazygit (Root Dir)' })
	map('n', '<leader>gT', function() Snacks.lazygit() end, { desc = 'Lazygit (cwd)' })
	map('n', '<leader>gF', function() Snacks.picker.git_log_file() end, { desc = 'Git Current File History' })
	---@diagnostic disable-next-line: missing-fields
	map('n', '<leader>gl', function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, { desc = 'Git Log' })
	map('n', '<leader>gL', function() Snacks.picker.git_log() end, { desc = 'Git Log (cwd)' })
end

map('n', '<leader>gm', function() Snacks.picker.git_log_line() end, { desc = 'Git Blame Line' })
map({ 'n', 'x' }, '<leader>go', function() Snacks.gitbrowse() end, { desc = 'Git Browse' })
map({ 'n', 'x' }, '<leader>gY', function()
	---@diagnostic disable-next-line: missing-fields
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

map('n', 's', '<Nop>', { desc = '+screen' })
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
-- Tabs {{{
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
-- }}}

-- FUNCTIONS
-- ===

-- Get visually selected lines.
-- Source: https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/utils.lua
---@return string
function _G.get_visual_selection() -- {{{
	-- this will exit visual mode
	-- use 'gv' to reselect the text
	local _, csrow, cscol, cerow, cecol
	local mode = vim.fn.mode()
	local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, mode)
	if is_visual then
		-- if we are in visual mode use the live position
		_, csrow, cscol, _ = unpack(vim.fn.getpos('.') or { 0, 0, 0, 0 })
		_, cerow, cecol, _ = unpack(vim.fn.getpos('v') or { 0, 0, 0, 0 })
		if mode == 'V' then
			-- visual line doesn't provide columns
			cscol, cecol = 0, 999
		end
	else
		-- otherwise, use the last known visual position
		_, csrow, cscol, _ = unpack(vim.fn.getpos("'<") or { 0, 0, 0, 0 })
		_, cerow, cecol, _ = unpack(vim.fn.getpos("'>") or { 0, 0, 0, 0 })
	end
	-- swap vars if needed
	if cerow < csrow then
		csrow, cerow = cerow, csrow
	end
	if cecol < cscol then
		cscol, cecol = cecol, cscol
	end
	local lines = vim.fn.getline(csrow, cerow)
	-- local n = cerow-csrow+1
	local n = #lines
	if n <= 0 or type(lines) ~= 'table' then
		return ''
	end
	lines[n] = string.sub(lines[n], 1, cecol)
	lines[1] = string.sub(lines[1], cscol)
	return table.concat(lines, '\n')
end -- }}}

-- Append modeline at end of file.
function _G.append_modeline() -- {{{
	local modeline = string.format(
		'vim: set ts=%d sw=%d tw=%d %set :',
		vim.bo.tabstop,
		vim.bo.shiftwidth,
		vim.bo.textwidth,
		vim.bo.expandtab and '' or 'no'
	)
	local cs = vim.bo.commentstring
	local ok, tccs = pcall(require, 'ts_context_commentstring.internal')
	if ok then
		local ts_cs = tccs.calculate_commentstring()
		if ts_cs then
			cs = ts_cs
		end
	end
	if not cs then
		LazyVim.warn('No commentstring found')
		return
	end
	modeline = string.gsub(cs, '%%s', modeline)
	vim.api.nvim_buf_set_lines(0, -1, -1, false, { modeline })
end -- }}}

-- Go to newer/older buffer through jumplist.
---@param direction 1 | -1
function _G.jump_buffer(direction) -- {{{
	local jumplist, curjump = unpack(vim.fn.getjumplist() or { 0, 0 })
	if #jumplist == 0 then
		return
	end
	local cur_buf = vim.api.nvim_get_current_buf()
	local jumpcmd = direction > 0 and '<C-i>' or '<C-o>'
	local searchrange = {}
	curjump = curjump + 1
	if direction > 0 then
		searchrange = vim.fn.range(curjump + 1, #jumplist)
	else
		searchrange = vim.fn.range(curjump - 1, 1, -1)
	end

	for _, i in ipairs(searchrange) do
		local nr = jumplist[i]['bufnr']
		if nr ~= cur_buf and vim.fn.bufname(nr):find('^%w+://') == nil then
			local n = tostring(math.abs(i - curjump))
			vim.notify('Executing ' .. jumpcmd .. ' ' .. n .. ' times')
			jumpcmd = vim.api.nvim_replace_termcodes(jumpcmd, true, true, true)
			vim.cmd.normal({ n .. jumpcmd, bang = true })
			break
		end
	end
end -- }}}

-- Jump to next/previous whitespace error.
---@param direction 1 | -1
function _G.whitespace_jump(direction) -- {{{
	local opts = 'wz'
	if direction < 1 then
		opts = opts .. 'b'
	end

	-- Whitespace pattern: Trailing whitespace or mixed tabs/spaces.
	local pat = '\\s\\+$\\| \\+\\ze\\t'
	vim.fn.search(pat, opts)
end -- }}}

-- Toggle list window
---@param name "quickfix" | "loclist"
function _G.toggle_list(name) -- {{{
	for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(win) and vim.fn.win_gettype(win) == name then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	if name == 'loclist' then
		vim.cmd([[ botright lopen ]])
	else
		vim.cmd([[ botright copen ]])
	end
end -- }}}

-- Display a list of formatters and apply the selected one.
function _G.formatter_select() -- {{{
	local buf = vim.api.nvim_get_current_buf()
	local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, vim.fn.mode())
	local cur_start, cur_end
	if is_visual then
		cur_start = vim.fn.getpos('.')
		cur_end = vim.fn.getpos('v')
	end

	-- Collect various sources of formatters.
	---@class rafi.Formatter
	---@field kind string
	---@field name string
	---@field client LazyFormatter|{active:boolean,resolved:string[]}

	---@type rafi.Formatter[]
	local sources = {}
	local fmts = LazyVim.format.resolve(buf)
	for _, fmt in ipairs(fmts) do
		vim.tbl_map(function(resolved)
			table.insert(sources, {
				kind = fmt.name,
				name = resolved,
				client = fmt,
			})
		end, fmt.resolved)
	end

	local total_sources = #sources

	-- Apply formatter source on buffer.
	---@param bufnr number
	---@param source rafi.Formatter
	local apply_source = function(bufnr, source)
		if source == nil then
			return
		end
		LazyVim.try(function()
			return source.client.format(bufnr)
		end, { msg = 'Formatter `' .. source.name .. '` failed' })
	end

	if total_sources == 1 then
		apply_source(buf, sources[1])
	elseif total_sources > 1 then
		-- Display a list of sources to choose from
		vim.ui.select(sources, {
			prompt = 'Select a formatter',
			format_item = function(item)
				return item.name .. ' (' .. item.kind .. ')'
			end,
		}, function(selected)
			if is_visual then
				-- Restore visual selection
				vim.fn.setpos('.', cur_start)
				vim.cmd([[normal! v]])
				vim.fn.setpos('.', cur_end)
			end
			apply_source(buf, selected)
		end)
	else
		vim.notify(
			'No configured formatters for this filetype.',
			vim.log.levels.WARN
		)
	end
end -- }}}

-- vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
