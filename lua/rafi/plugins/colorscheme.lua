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
			flavour = 'mocha', -- latte, frappe, macchiato, mocha
			dim_inactive = { enabled = false },
			integrations = {
				alpha = true,
				cmp = true,
				flash = true,
				gitsigns = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				lsp_trouble = true,
				markdown = true,
				mason = true,
				mini = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { 'italic' },
						hints = { 'italic' },
						warnings = { 'italic' },
						information = { 'italic' },
					},
					underlines = {
						errors = { 'undercurl' },
						hints = { 'undercurl' },
						warnings = { 'undercurl' },
						information = { 'undercurl' },
					},
					inlay_hints = {
						background = true,
					},
				},
				navic = { enabled = true },
				neogit = true,
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				semantic_tokens = true,
				symbols_outline = true,
				treesitter_context = true,
				telescope = { enabled = true },
				treesitter = true,
				which_key = true,
			},
		},
	},
}
