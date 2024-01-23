-- Plugins: Colorschemes
-- https://github.com/rafi/vim-config

return {

	-- Use last-used colorscheme
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
		'ribru17/bamboo.nvim',
		config = function()
			require('bamboo').setup({})
			require('bamboo').load()
		end,
	},

	-- Soothing pastel theme
	{
		'catppuccin/nvim',
		lazy = true,
		name = 'catppuccin',
		opts = {
			flavour = 'macchiato', -- latte, frappe, macchiato, mocha
			dim_inactive = { enabled = false },
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dashboard = true,
				flash = true,
				gitsigns = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				markdown = true,
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
				navic = { enabled = true, custom_bg = 'lualine' },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				semantic_tokens = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		},
	},
}
