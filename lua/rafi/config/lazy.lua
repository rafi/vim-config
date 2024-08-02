-- Rafi's lazy.nvim initialization
-- https://github.com/rafi/vim-config

-- Clone bootstrap repositories if not already installed.
local function clone(remote, dest)
	if not vim.uv.fs_stat(dest) then
		print('Installing ' .. dest .. '…')
		remote = 'https://github.com/' .. remote
		-- stylua: ignore
		vim.fn.system({ 'git', 'clone', '--filter=blob:none', remote, '--branch=stable', dest })
	end
end

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
clone('folke/lazy.nvim.git', lazypath)
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
clone('LazyVim/LazyVim.git', vim.fn.stdpath('data') .. '/lazy/LazyVim')

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
		{ import = 'rafi.plugins.lazyvim' },
		{ import = 'rafi.plugins' },
		{ import = 'lazyvim.plugins.xtras' },
		has_user_plugins and { import = 'plugins' } or nil,
	},
	concurrency = vim.uv.available_parallelism() * 2,
	defaults = { lazy = true, version = false },
	dev = { path = vim.fn.stdpath('config') .. '/dev' },
	install = { missing = true, colorscheme = {} },
	checker = { enabled = true, notify = false },
	change_detection = { notify = false },
	ui = {
		size = { width = 0.8, height = 0.85 },
		border = 'rounded',
		wrap = false,
	},
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
