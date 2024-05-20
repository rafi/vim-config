-- Rafael Bodill's lazy.nvim initialization
-- https://github.com/rafi/vim-config

-- Clone bootstrap repositories if not already installed.
vim.uv = vim.uv or vim.loop
local function clone(remote, dest)
	if not vim.uv.fs_stat(dest) then
		print('Installing ' .. dest .. '…')
		-- stylua: ignore
		vim.fn.system({ 'git', 'clone', '--filter=blob:none', remote, '--branch=stable', dest })
	end
end
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
clone('https://github.com/folke/lazy.nvim.git', lazypath)
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
clone('https://github.com/LazyVim/LazyVim.git', vim.fn.stdpath('data') .. '/lazy/LazyVim')

-- Load user options from lua/config/setup.lua
local user_lazy_opts = {}
local ok, user_setup = pcall(require, 'config.setup')
if ok and user_setup.lazy_opts then
	user_lazy_opts = user_setup.lazy_opts() or {}
end

-- Validate if lua/plugins/ or lua/plugins.lua exist.
local user_path = vim.fn.stdpath('config') .. '/lua'
local has_user_plugins = vim.uv.fs_stat(user_path .. '/plugins') ~= nil
	or vim.uv.fs_stat(user_path .. '/plugins.lua') ~= nil

-- Start lazy.nvim plugin manager.
require('lazy').setup(vim.tbl_extend('keep', user_lazy_opts, {
	spec = {
		-- Load LazyVim, but without any plugins (no import).
		-- See all options in lua/rafi/plugins/lazyvim.lua
		{
			'LazyVim/LazyVim',
			version = '*',
			priority = 10000,
			lazy = false,
			cond = true,
			opts = {},
			config = function(_, opts)
				-- Load lua/rafi/config/*
				require('rafi.config').setup()
				-- Setup lazyvim, but don't load lazyvim/config/* files.
				package.loaded['lazyvim.config.options'] = true
				require('lazyvim.config').setup(vim.tbl_deep_extend('force', opts, {
					defaults = { autocmds = false, keymaps = false },
					news = { lazyvim = false },
				}))
			end,
		},

		-- Load RafiVim plugins
		{ import = 'rafi.plugins' },

		-- Load custom user lua/plugins.lua or lua/plugins/*
		has_user_plugins and { import = 'plugins' } or nil,

		-- Load LazyExtras
		{ import = 'lazyvim.plugins.xtras' },
	},
	concurrency = vim.uv.available_parallelism() * 2,
	defaults = { lazy = true, version = false },
	dev = { path = vim.fn.stdpath('config') .. '/dev' },
	install = { missing = true, colorscheme = {} },
	checker = { enabled = true, notify = false },
	change_detection = { notify = false },
	ui = { border = 'rounded' },
	diff = { cmd = 'terminal_git' },
	performance = {
		rtp = {
			disabled_plugins = {
				'gzip',
				'vimballPlugin',
				'matchit',
				'matchparen',
				'2html_plugin',
				'tarPlugin',
				'netrwPlugin',
				'tutor',
				'zipPlugin',
			},
		},
	},
}))

-- Enjoy!
