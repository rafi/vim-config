-- Rafi's Neovim options
-- github.com/rafi/vim-config
-- ===

-- This file is automatically loaded by config.init or plugins.core

-- Keyboard leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- LazyVim auto format
vim.g.autoformat = false

-- LazyVim picker to use.
-- Can be one of: telescope, fzf
-- Leave it to "auto" to automatically use the picker
-- enabled with `:LazyExtras`
vim.g.lazyvim_picker = 'auto'

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

-- LazyVim automatically configures lazygit:
--  * theme, based on the active colorscheme.
--  * editorPreset to nvim-remote
--  * enables nerd font icons
-- Set to false to disable.
vim.g.lazygit_config = true

-- Options for the LazyVim statuscolumn
vim.g.lazyvim_statuscolumn = {
	folds_open = false, -- show fold sign when fold is open
	folds_githl = false, -- highlight fold sign with git sign color
}

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Set filetype to `bigfile` for files larger than 1.5 MB
-- Only vim syntax will be enabled (with the correct filetype)
-- LSP, treesitter and other ft plugins will be disabled.
-- mini.animate will also be disabled.
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

-- Show the current document symbols location from Trouble in lualine
vim.g.trouble_lualine = false

-- General
-- ===
-- stylua: ignore start

local opt = vim.opt

opt.title = true
opt.titlestring = '%<%F%=%l/%L - nvim'
opt.mouse = 'nv'               -- Enable mouse in normal and visual modes only
opt.virtualedit = 'block'      -- Position cursor anywhere in visual block
opt.confirm = true             -- Confirm unsaved changes before exiting buffer
opt.conceallevel = 2           -- Hide * markup for bold and italic, but not markers with substitutions
opt.signcolumn = 'yes'         -- Always show signcolumn
opt.spelllang = { 'en' }
opt.spelloptions:append('camel')
opt.spelloptions:append('noplainbuffer')
opt.updatetime = 200           -- Idle time to write swap and trigger CursorHold
if not vim.g.vscode then
	opt.timeoutlen = 500  -- Time out on mappings
	opt.ttimeoutlen = 10  -- Time out on key codes
end

-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus' -- Sync with system clipboard

opt.completeopt = 'menu,menuone,noselect'
opt.wildmode = 'longest:full,full'
opt.diffopt:append({ 'indent-heuristic', 'algorithm:patience' })

opt.textwidth = 80             -- Text width maximum chars before wrapping
opt.tabstop = 2                -- The number of spaces a tab is
opt.smartindent = true         -- Smart autoindenting on new lines
opt.shiftwidth = 2             -- Number of spaces to use in auto(indent)
opt.shiftround = true          -- Round indent to multiple of 'shiftwidth'

-- What to save for views and sessions
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
opt.jumpoptions = 'view'

-- Formatting
-- ===

opt.wrap = false                -- No wrap by default
opt.linebreak = true            -- Break long lines at 'breakat'
opt.breakindent = true
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"

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
opt.laststatus = 3        -- Global statusline
opt.scrolloff = 4         -- Keep at least 2 lines above/below
opt.sidescrolloff = 8     -- Keep at least 5 lines left/right
opt.numberwidth = 2       -- Minimum number of columns to use for the line number
opt.number = false        -- Don't show line numbers
opt.ruler = false         -- Disable default status ruler
opt.list = true           -- Show hidden characters
opt.foldlevel = 99
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
	foldopen = '', -- 󰅀 
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

opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]

if vim.fn.has('nvim-0.10') == 1 then
	opt.smoothscroll = true
	vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
	vim.opt.foldmethod = 'expr'
	vim.opt.foldtext = ''
else
	vim.opt.foldmethod = 'indent'
	vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
end

-- Misc
-- ===

-- Disable python/perl/ruby/node providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
vim.g.yaml_indent_multiline_scalar = 1

vim.g.no_gitrebase_maps = 1 -- See share/nvim/runtime/ftplugin/gitrebase.vim
vim.g.no_man_maps = 1       -- See share/nvim/runtime/ftplugin/man.vim

-- Filetype detection
-- ===

vim.filetype.add({
	filename = {
		Brewfile = 'ruby',
		justfile = 'just',
		Justfile = 'just',
		['.buckconfig'] = 'toml',
		['.flowconfig'] = 'ini',
		['.jsbeautifyrc'] = 'json',
		['.jscsrc'] = 'json',
		['.watchmanconfig'] = 'json',
		['helmfile.yaml'] = 'yaml',
		['todo.txt'] = 'todotxt',
		['yarn.lock'] = 'yaml',
	},
	pattern = {
		['%.config/git/users/.*'] = 'gitconfig',
		['%.kube/config'] = 'yaml',
		['.*%.js%.map'] = 'json',
		['.*%.postman_collection'] = 'json',
		['Jenkinsfile.*'] = 'groovy',
	},
})

-- vim: set ts=2 sw=0 tw=80 noet :
