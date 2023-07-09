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
	{ 'folke/tokyonight.nvim', opts = { style = 'night' } },
	{ 'rebelot/kanagawa.nvim' },
	{ 'olimorris/onedarkpro.nvim' },
	{ 'EdenEast/nightfox.nvim' },
	{ 'nyoom-engineering/oxocarbon.nvim' },

	{
		'catppuccin/nvim',
		lazy = true,
		name = 'catppuccin',
		opts = {
			integrations = {
				alpha = true,
				cmp = true,
				gitsigns = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				lsp_trouble = true,
				mason = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { 'undercurl' },
						hints = { 'undercurl' },
						warnings = { 'undercurl' },
						information = { 'undercurl' },
					},
				},
				navic = { enabled = true },
				neotest = true,
				noice = true,
				notify = true,
				neotree = true,
				semantic_tokens = true,
				telescope = true,
				treesitter = true,
				which_key = true,
			},
		},
	},
}
