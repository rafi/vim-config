-- Rafael Bodill's Neovim entry-point
-- https://github.com/rafi/vim-config

local config = require('rafi.config')
config.ensure_lazy()
config.setup()

-- Setup Lazy.nvim with plugins specs.
local spec = {
	{ import = 'rafi.plugins' },
}

-- Add user's specs if exist.
if config.has_user_plugins() then
	table.insert(spec, { import = 'plugins' })
end

-- Start lazy.nvim plugin manager.
require('lazy').setup({
	spec = spec,
	defaults = { lazy = true, version = false },
	dev = { path = config.path_join(vim.fn.stdpath('config'), 'dev') },
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
})

-- Restore last used colorscheme, or set initial.
require('theme-loader').start()

-- Enjoy!
