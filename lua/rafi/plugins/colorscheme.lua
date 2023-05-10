-- Plugins: Colorschemes
-- https://github.com/rafi/vim-config

return {

	{
		'rafi/theme-loader.nvim',
		lazy = false,
		priority = 99,
		opts = { initial_colorscheme = 'neohybrid' },
	},

	{ 'rafi/neo-hybrid.vim', priority = 100, lazy = false },
	{ 'rafi/awesome-vim-colorschemes', lazy = false },
	{ 'AlexvZyl/nordic.nvim' },
	{ 'folke/tokyonight.nvim', opts = { style = 'night' }},
	{ 'rebelot/kanagawa.nvim' },
	{ 'olimorris/onedarkpro.nvim' },
	{ 'EdenEast/nightfox.nvim' },
	{ 'catppuccin/nvim', name = 'catppuccin' },
	{ 'nyoom-engineering/oxocarbon.nvim' },

}
