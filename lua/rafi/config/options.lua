-- Rafi's Neovim options
-- https://github.com/rafi/vim-config
-- ===

-- This file is automatically loaded by lua/rafi/config/lazy.lua
-- Extends $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/config/options.lua

-- Keyboard leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- Enable elite-mode (hjkl mode. arrow-keys resize window)
vim.g.elite_mode = false

-- External file diff program
vim.g.diffprg = 'bcompare'

-- Disable LazyVim features.
vim.g.autoformat = false -- LazyVim auto format

local opt = vim.opt

opt.autowrite = false
opt.expandtab = false
opt.number = false
opt.relativenumber = false

opt.title = true
opt.titlestring = '%<%F%=%l/%L - nvim'
opt.textwidth = 80             -- Text width maximum chars before wrapping
opt.mouse = 'nv'               -- Enable mouse in normal and visual modes only
opt.spelloptions:append('camel')
opt.diffopt:append({
	'indent-heuristic',
	'algorithm:patience',
	'context:999999'
})

if not vim.g.vscode then
	opt.timeoutlen = 500  -- Faster timeout on mapped sequence to complete.
	opt.ttimeoutlen = 10  -- Faster timeout on key code sequence to complete.
end

if vim.fn.has('nvim-0.11') == 1 then
	opt.tabclose:append({'uselast'})
end

-- What to save for views and sessions
opt.sessionoptions:remove({ 'blank', 'buffers', 'terminal' })

opt.breakindent = true
opt.showcmd = false       -- Don't show command in status line
opt.numberwidth = 2       -- Minimum number of columns for the line number
opt.cmdheight = 0
opt.colorcolumn = '+0'    -- Align text at 'textwidth'
opt.showtabline = 2       -- Always show the tabs line
opt.helpheight = 0        -- Disable help window resizing
opt.winwidth = 30         -- Minimum width for active window
opt.winheight = 1         -- Minimum height for active window
opt.winminheight = 1      -- Minimum height for inactive window

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
	foldopen = '', --  󰅀
	foldclose = '', --  󰅂
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

-- Disable python/perl/ruby/node providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Neovim built in filetype plugins settings.
vim.g.markdown_recommended_style = 0    -- $VIMRUNTIME/ftplugin/markdown.vim
vim.g.yaml_indent_multiline_scalar = 1  -- $VIMRUNTIME/indent/yaml.vim
vim.g.no_gitrebase_maps = 1  -- See $VIMRUNTIME/ftplugin/gitrebase.vim
vim.g.no_man_maps = 1        -- See $VIMRUNTIME/ftplugin/man.vim

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

vim.filetype.add({
	extension = {
		mdc = 'markdown',
	},
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

		-- NEW
		['.envrc'] = 'bash',
		['.env'] = 'dotenv',
		['.stylelintrc'] = 'json',
		['.stylelintignore'] = 'gitignore',
		['.eslintrc.json'] = 'json5',
		['.luarc.json'] = 'json5',
		['turbo.json'] = 'json5',
		['nx.json'] = 'json5',
		PULLREQ_EDITMSG = 'markdown.ghpull',
		ISSUE_EDITMSG = 'markdown.ghissue',
		RELEASE_EDITMSG = 'markdown.ghrelease',
	},
	pattern = {
		['%.config/git/users/.*'] = 'gitconfig',
		['%.kube/config'] = 'yaml',
		['.*%.js%.map'] = 'json',
		['.*%.postman_collection'] = 'json',
		['Jenkinsfile.*'] = 'groovy',

		-- JSON with comments
		['[jt]sconfig*.json'] = 'json5',

		-- INFO: Match filenames like - ".env.example", ".env.local" and so on
		-- needed to make dotenv-linter with null-ls works correctly
		['%.env%.[%w_.-]+'] = 'dotenv',
		['.*%.gradle'] = 'groovy',
		['.*/%.github/.*%.y*ml'] = 'yaml.github',

		-- For docker compose language
		-- ['compose.y.?ml'] = 'yaml.docker-compose',
		-- ['docker%-compose%.y.?ml'] = 'yaml.docker-compose',
	},
})

-- vim: set ts=2 sw=0 tw=80 noet :
