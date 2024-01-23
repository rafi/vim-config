-- Rafi's Neovim options
-- github.com/rafi/vim-config
-- ===

-- This file is automatically loaded by config.init or plugins.core
-- stylua: ignore start

-- Keyboard leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- Enable LazyVim auto format
vim.g.autoformat = false

-- Enable elite-mode (hjkl mode. arrow-keys resize window)
vim.g.elite_mode = false

-- When enabled, 'q' closes any window
vim.g.window_q_mapping = true

-- Display structure in statusline by default
vim.g.structure_status = false

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

-- General
-- ===

local opt = vim.opt

opt.title = true
opt.titlestring = "%<%F%=%l/%L - nvim"
opt.mouse = 'nv'               -- Disable mouse in command-line mode
opt.virtualedit = 'block'      -- Position cursor anywhere in visual block
opt.confirm = true             -- Confirm unsaved changes before exiting buffer
opt.clipboard = 'unnamedplus'  -- Sync with system clipboard
opt.conceallevel = 3           -- Hide concealed text
opt.signcolumn = 'yes'         -- Always show signcolumn
opt.spelllang = { 'en' }
opt.spelloptions:append('camel')
opt.timeoutlen = 300           -- Time out on mappings
opt.updatetime = 200           -- Idle time to write swap and trigger CursorHold

opt.completeopt = 'menu,menuone,noinsert'
opt.wildmode = 'longest:full,full'  -- Command-line completion mode
opt.diffopt:append({ 'iwhite', 'indent-heuristic', 'algorithm:patience' })

opt.textwidth = 80             -- Text width maximum chars before wrapping
opt.tabstop = 2                -- The number of spaces a tab is
opt.smartindent = true         -- Smart autoindenting on new lines
opt.shiftwidth = 2             -- Number of spaces to use in auto(indent)
opt.shiftround = true          -- Round indent to multiple of 'shiftwidth'

-- What to save for views and sessions
opt.viewoptions:remove('folds')
opt.sessionoptions:remove({ 'blank', 'buffers', 'terminal' })
opt.sessionoptions:append({ 'globals', 'skiprtp' })

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

-- Searching
-- ===
opt.ignorecase = true -- Search ignoring case
opt.smartcase = true  -- Keep case when searching with *
opt.inccommand = 'nosplit' -- Preview incremental substitute
opt.grepformat = '%f:%l:%c:%m'
-- opt.path:append('**') -- Find recursively

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
opt.breakindent = true
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

-- Editor UI
-- ===

opt.termguicolors = true  -- True color support
opt.shortmess:append({ W = true, I = true, c = true })  --  (default "ltToOCF")
opt.showcmd = false       -- Don't show command in status line
opt.showmode = false      -- Don't show mode in cmd window
opt.scrolloff = 4         -- Keep at least 2 lines above/below
opt.sidescrolloff = 8     -- Keep at least 5 lines left/right
opt.numberwidth = 2       -- Minimum number of columns to use for the line number
opt.number = false        -- Don't show line numbers
opt.ruler = false         -- Disable default status ruler
opt.list = true           -- Show hidden characters
opt.cursorline = true     -- Highlight the text line under the cursor
opt.splitbelow = true     -- New split at bottom
opt.splitright = true     -- New split on right
opt.splitkeep = 'screen'  -- New split keep the text on the same screen line

opt.cmdheight = 0
opt.colorcolumn = '+0'    -- Align text at 'textwidth'
opt.showtabline = 2       -- Always show the tabs line
opt.helpheight = 0        -- Disable help window resizing
opt.winwidth = 30         -- Minimum width for active window
opt.winminwidth = 1       -- Minimum width for inactive windows
opt.winheight = 1         -- Minimum height for active window
opt.winminheight = 1      -- Minimum height for inactive window
opt.pumblend = 10         -- Popup blend
opt.pumheight = 10        -- Maximum number of items to show in the popup menu

opt.showbreak = '⤷  ' -- ↪	⤷
opt.listchars = {
	tab = '  ',
	extends = '⟫',
	precedes = '⟪',
	conceal = '',
	nbsp = '␣',
	trail = '·'
}
opt.fillchars = {
	foldopen = '󰅀', -- 󰅀 
	foldclose = '', -- 󰅂 
	fold = ' ', -- ⸱
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

if vim.fn.has('nvim-0.10') == 1 then
	opt.smoothscroll = true
end

-- Folds
-- ===

opt.foldlevel = 99
-- opt.foldlevelstart = 99

vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"

if vim.fn.has('nvim-0.9.0') == 1 then
	vim.opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]
end

-- HACK: causes freezes on <= 0.9, so only enable on >= 0.10 for now
if vim.fn.has('nvim-0.10') == 1 then
	vim.opt.foldmethod = 'expr'
	vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
else
	vim.opt.foldmethod = 'indent'
end

vim.o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"

-- Misc
-- ===

-- Disable python/perl/ruby/node providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.g.no_gitrebase_maps = 1 -- See share/nvim/runtime/ftplugin/gitrebase.vim
vim.g.no_man_maps = 1       -- See share/nvim/runtime/ftplugin/man.vim

-- Filetype detection
-- ===

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
		['helmfile.yaml'] = 'yaml',
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
