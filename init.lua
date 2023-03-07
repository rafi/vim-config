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

require('lazy').setup({
	spec = spec,
	defaults = { lazy = true },
	dev = { path = config.path_join(vim.fn.stdpath('config'), 'dev') },
	install = { missing = true, colorscheme = {} },
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
config.init_colorscheme()

-- Enjoy!
