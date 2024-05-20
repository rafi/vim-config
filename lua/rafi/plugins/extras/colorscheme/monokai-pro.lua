return {

	-- Monokai Pro theme with multiple filters: Pro, Classic, Machine, Octagon,
	-- Ristretto, Spectrum.
	{
		'loctvl842/monokai-pro.nvim',
		lazy = false,
		priority = 1000,
		opts = {
			filter = 'pro', -- classic | octagon | pro | machine | ristretto | spectrum
			plugins = {
				bufferline = {
					underline_selected = false,
					underline_visible = false,
				},
				indent_blankline = {
					context_highlight = 'pro', -- default | pro
					context_start_underline = false,
				},
			},
		},
	},
}
