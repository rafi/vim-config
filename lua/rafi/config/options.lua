-- Rafi's Neovim options
-- https://github.com/rafi/vim-config
-- ===
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- This file is automatically loaded by rafi.config.setup() (init.lua)

-- Keyboard leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- Add user pack directory
vim.opt.packpath:append(vim.fn.stdpath('data') .. '/site')

-- Auto format on save (rafi.util.format)
vim.g.autoformat = false

-- Elite-mode (hjkl mode, arrow-keys resize window), off by default.
vim.g.elite_mode = false

-- Snacks animations. Set to `false` to disable all of them.
vim.g.snacks_animate = true

-- Use the AI completion source instead of inline suggestions, when the
-- completion engine supports it
vim.g.ai_cmp = true

-- <Tab> selects completion items, jumps in snippets and opens completion.
-- false keeps <Tab> for snippet jumps and AI actions only.
vim.g.cmp_supertab = true

-- External file diff program
vim.g.diffprg = 'bcompare'

-- Root dir detection (rafi.util.root)
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

-- LSP servers ignored by root detection
vim.g.root_lsp_ignore = { 'copilot' }

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Show document symbols location from Trouble in lualine.
-- Disable per buffer with `vim.b.trouble_lualine = false`.
vim.g.trouble_lualine = true

-- Skip clipboard over SSH, so the OSC 52 integration works.
vim.opt.clipboard = vim.env.SSH_CONNECTION and '' or 'unnamedplus' -- Sync with system clipboard
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'indent'
vim.opt.foldtext = ''
vim.opt.formatoptions = 'jcroqlnt' -- tcqj
vim.opt.formatexpr = "v:lua.require'rafi.util.format'.formatexpr()"
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.ignorecase = true -- Ignore case
vim.opt.inccommand = 'nosplit' -- preview incremental substitute
vim.opt.jumpoptions = 'view'
vim.opt.laststatus = 3 -- global statusline
vim.opt.linebreak = true -- Wrap lines at convenient points
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.ruler = false -- Disable the default ruler
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sessionoptions = {
	'curdir',
	'tabpages',
	'winsize',
	'help',
	'globals',
	'skiprtp',
	'folds',
}
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.smoothscroll = true
vim.opt.spelllang = { 'en' }
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = 'screen'
vim.opt.splitright = true -- Put new windows right of current
vim.opt.statuscolumn = [[%!v:lua.require'rafi.util'.statuscolumn()]]
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = 'longest:full,full' -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
-- Disable markdown.vim [[/]] keymaps, the built-in ftplugin sets them
vim.g.no_markdown_maps = 1

-- Neovim built in filetype plugins settings.
vim.g.yaml_indent_multiline_scalar = 1 -- $VIMRUNTIME/indent/yaml.vim
vim.g.no_gitrebase_maps = 1 -- See $VIMRUNTIME/ftplugin/gitrebase.vim
vim.g.no_man_maps = 1 -- See $VIMRUNTIME/ftplugin/man.vim

-- Disable unused builtin plugins
for _, name in ipairs({
	'gzip',
	'matchit',
	'matchparen',
	'tarPlugin',
	'netrwPlugin',
	'zipPlugin', -- plugin/zipPlugin.vim (Neovim 0.12)
	'python3_provider',
	'perl_provider',
	'ruby_provider',
	'node_provider',
}) do
	vim.g['loaded_' .. name] = 1
end
-- Guard names that differ from the file names above.
vim.g.loaded_tutor_mode_plugin = 1 -- plugin/tutor.vim
vim.g.loaded_nvim_zip_plugin = 1 -- plugin/zip.lua (Neovim 0.13+)

vim.opt.autowrite = false
vim.opt.expandtab = false
vim.opt.number = false
vim.opt.relativenumber = false

vim.opt.title = true
vim.opt.titlestring = '%<%F%=%l/%L - nvim'
vim.opt.textwidth = 80 -- Text width maximum chars before wrapping
vim.opt.mouse = 'nv' -- Enable mouse in normal and visual modes only
vim.opt.mousescroll = 'ver:1,hor:1'
vim.opt.spelloptions:append('camel')
vim.opt.diffopt:append({
	'indent-heuristic',
	'algorithm:patience',
	'context:999999',
})

if not vim.g.vscode then
	-- Faster timeout on mapped/key-code sequence to complete.
	vim.opt.timeoutlen = vim.g.vscode and 1000 or 300
	vim.opt.ttimeoutlen = 10
end

if vim.fn.has('nvim-0.11') == 1 then
	vim.opt.tabclose:append('uselast')
end

vim.opt.breakindent = true
vim.opt.showcmd = false -- Don't show command in status line
vim.opt.numberwidth = 2 -- Minimum number of columns for the line number
vim.opt.cmdheight = 0
vim.opt.colorcolumn = '+0' -- Align text at 'textwidth'
vim.opt.showtabline = 2 -- Always show the tabs line
vim.opt.helpheight = 0 -- Disable help window resizing
vim.opt.winwidth = 30 -- Minimum width for active window
vim.opt.winheight = 1 -- Minimum height for active window
vim.opt.winminheight = 1 -- Minimum height for inactive window
vim.opt.winborder = 'rounded' -- Default border style of floating windows

if vim.fn.has('nvim-0.13') == 1 then
	vim.opt.shortmess:append('u')
end

vim.opt.showbreak = '⤷  ' -- ↪	⤷
vim.opt.listchars = {
	tab = '  ',
	extends = '⟫',
	precedes = '⟪',
	conceal = '',
	nbsp = '␣',
	trail = '·',
}
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 15
-- vim.wo.foldcolumn = '1'
vim.opt.fillchars = {
	foldopen = '', --  󰅀▾
	foldclose = '', --  󰅂▸
	fold = ' ', -- ⸱
	foldsep = ' ',
	foldinner = ' ',
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

-- If sudo, disable vim swap/backup/undo/shada writing
local USER = vim.env.USER or ''
local SUDO_USER = vim.env.SUDO_USER or ''
if
	SUDO_USER ~= ''
	and USER ~= SUDO_USER
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

-- The clipboard is set after startup in rafi.config.setup(), so that a
-- user override in lua/config/options.lua is kept.

-- vim: set ts=2 sw=0 tw=80 noet :
