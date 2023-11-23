-- Rafi's Neovim options
-- github.com/rafi/vim-config
-- ===

-- This file is automatically loaded by config.init or plugins.core
-- stylua: ignore start

-- Keyboard leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- General
-- ===

local opt = vim.opt

opt.mouse = 'nv'       -- Disable mouse in command-line mode
opt.errorbells = true  -- Trigger bell on error
opt.visualbell = true  -- Use visual bell instead of beeping
opt.hidden = true      -- Hide buffers when abandoned instead of unload
opt.virtualedit = 'block'  -- Position cursor anywhere in visual block
opt.confirm = true     -- Confirm to save changes before exiting modified buffer

-- History and persistence
opt.history = 5000
opt.shada = { "'1000", "<50", "s10", "h" }

opt.conceallevel = 3
opt.signcolumn = 'yes'
opt.spelloptions:append('camel')

-- What to save for views and sessions
opt.viewoptions:remove('folds')
opt.sessionoptions:remove({ 'buffers', 'folds' })

-- Sync with system clipboard
opt.clipboard = 'unnamedplus'

-- Undo
opt.undofile = true
opt.undolevels = 10000
opt.writebackup = false

-- If sudo, disable vim swap/backup/undo/shada writing
local USER = vim.env.USER or ''
local SUDO_USER = vim.env.SUDO_USER or ''
if
	SUDO_USER ~= '' and USER ~= SUDO_USER
	and vim.env.HOME ~= vim.fn.expand('~' .. USER, true)
	and vim.env.HOME == vim.fn.expand('~' .. SUDO_USER, true)
then
	vim.opt_global.modeline = false
	vim.opt_global.undofile = false
	vim.opt_global.swapfile = false
	vim.opt_global.backup = false
	vim.opt_global.writebackup = false
	vim.opt_global.shadafile = 'NONE'
end

-- Tabs and Indents
-- ===

opt.textwidth = 80     -- Text width maximum chars before wrapping
opt.tabstop = 2        -- The number of spaces a tab is
opt.shiftwidth = 2     -- Number of spaces to use in auto(indent)
opt.smarttab = true    -- Tab insert blanks according to 'shiftwidth'
opt.autoindent = true  -- Use same indenting on new lines
opt.smartindent = true -- Smart autoindenting on new lines
opt.shiftround = true  -- Round indent to multiple of 'shiftwidth'

-- Timing
-- ===
opt.ttimeout = true
opt.timeoutlen = 500  -- Time out on mappings
opt.ttimeoutlen = 10  -- Time out on key codes
opt.updatetime = 500  -- Idle time to write swap and trigger CursorHold

-- Searching
-- ===
opt.ignorecase = true -- Search ignoring case
opt.smartcase = true  -- Keep case when searching with *
opt.infercase = true  -- Adjust case in insert completion mode
opt.incsearch = true  -- Incremental search
opt.inccommand = 'nosplit'
opt.grepformat = '%f:%l:%c:%m'
opt.path:append('**') -- Find recursively

if vim.fn.executable('rg') then
	opt.grepprg = 'rg --vimgrep --no-heading'
		.. (opt.smartcase and ' --smart-case' or '') .. ' --'
elseif vim.fn.executable('ag') then
	opt.grepprg = 'ag --vimgrep'
		.. (opt.smartcase and ' --smart-case' or '') .. ' --'
end

-- Formatting
-- ===

opt.wrap = false                -- No wrap by default
opt.linebreak = true            -- Break long lines at 'breakat'
opt.breakat = '\\ \\	;:,!?'    -- Long lines break chars
opt.startofline = false         -- Cursor in same column for few commands
opt.splitbelow = true           -- Splits open bottom right
opt.splitright = true
opt.breakindentopt = { shift = 2, min = 20 }
opt.formatoptions = opt.formatoptions
	- 'a' -- Auto formatting is BAD.
	- 't' -- Don't auto format my code. I got linters for that.
	+ 'c' -- In general, I like it when comments respect textwidth
	+ 'q' -- Allow formatting comments w/ gq
	- 'o' -- O and o, don't continue comments
	+ 'r' -- But do continue when pressing enter.
	+ 'n' -- Indent past the formatlistpat, not underneath it.
	+ 'j' -- Auto-remove comments if possible.
	- '2' -- I'm not in gradeschool anymore

-- Completion and Diff
-- ===

-- C-n completion
opt.complete:append('k')
opt.complete:remove('u')
opt.complete:remove('t')

opt.completeopt = 'menu,menuone,noselect'

opt.diffopt:append({ 'iwhite', 'indent-heuristic', 'algorithm:patience' })

opt.wildmode = 'longest:full,full' -- Command-line completion mode

-- Editor UI
-- ===

opt.termguicolors = true
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = false    -- Don't show mode in cmd window
opt.scrolloff = 2       -- Keep at least 2 lines above/below
opt.sidescrolloff = 5   -- Keep at least 5 lines left/right
opt.numberwidth = 2     -- Minimum number of columns to use for the line number
opt.number = false      -- Don't show line numbers
opt.ruler = false       -- Disable default status ruler
opt.list = true         -- Show hidden characters

opt.showtabline = 2     -- Always show the tabs line
opt.helpheight = 0      -- Disable help window resizing
opt.winwidth = 30       -- Minimum width for active window
opt.winminwidth = 1     -- Minimum width for inactive windows
opt.winheight = 1       -- Minimum height for active window
opt.winminheight = 1    -- Minimum height for inactive window

opt.showcmd = false     -- Don't show command in status line
opt.cmdheight = 0
opt.cmdwinheight = 5    -- Command-line lines
opt.equalalways = true  -- Resize windows on split or close
opt.colorcolumn = '+0'  -- Column highlight at textwidth's max character-limit

opt.cursorline = true
opt.cursorlineopt = { 'number', 'screenline' }

opt.pumheight = 10      -- Maximum number of items to show in the popup menu
opt.pumwidth = 10       -- Minimum width for the popup menu
opt.pumblend = 10       -- Popup blend

if vim.fn.has('nvim-0.9') == 1 then
	opt.splitkeep = 'screen'
	opt.shortmess:append({ C = true })
end

-- UI Symbols
-- ===
-- icons:  ▏│ ¦ ╎ ┆ ⋮ ⦙ ┊ 

opt.showbreak = '↳  '
opt.listchars = {
	tab = '  ',
	extends = '⟫',
	precedes = '⟪',
	nbsp = '␣',
	trail = '·'
}
opt.fillchars = {
	foldopen = '󰅀', -- 󰅀 
	foldclose = '󰅂', -- 󰅂 
	fold = ' ',
	foldsep = ' ',
	diff = '╱',
	eob = ' ',
	horiz = '━',
	horizup = '┻',
	horizdown = '┳',
	vert = '┃',
	vertleft = '┫',
	vertright = '┣',
	verthoriz = '╋',
}

-- Folds
-- ===

opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = '0'
opt.foldenable = true

-- Misc
-- ===

-- Disable python/perl/ruby/node providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.g.no_gitrebase_maps = 1 -- See share/nvim/runtime/ftplugin/gitrebase.vim
vim.g.no_man_maps = 1       -- See share/nvim/runtime/ftplugin/man.vim

-- Filetype detection
-- ===

---@diagnostic disable-next-line: missing-fields
vim.filetype.add({
	filename = {
		Brewfile = 'ruby',
		justfile = 'just',
		Justfile = 'just',
		Tmuxfile = 'tmux',
		['yarn.lock'] = 'yaml',
		['.buckconfig'] = 'toml',
		['.flowconfig'] = 'ini',
		['.jsbeautifyrc'] = 'json',
		['.jscsrc'] = 'json',
		['.watchmanconfig'] = 'json',
		['dev-requirements.txt'] = 'requirements',
	},
	pattern = {
		['.*%.js%.map'] = 'json',
		['.*%.postman_collection'] = 'json',
		['Jenkinsfile.*'] = 'groovy',
		['%.kube/config'] = 'yaml',
		['%.config/git/users/.*'] = 'gitconfig',
		['requirements-.*%.txt'] = 'requirements',
		['.*/templates/.*%.ya?ml'] = 'helm',
		['.*/templates/.*%.tpl'] = 'helm',
		['.*/playbooks/.*%.ya?ml'] = 'yaml.ansible',
		['.*/roles/.*/tasks/.*%.ya?ml'] = 'yaml.ansible',
		['.*/roles/.*/handlers/.*%.ya?ml'] = 'yaml.ansible',
		['.*/inventory/.*%.ini'] = 'ansible_hosts',
	},
})

-- vim: set ts=2 sw=0 tw=80 noet :
