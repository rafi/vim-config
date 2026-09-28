-- Monokai Pro colorscheme, with several filter variants

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/loctvl842/monokai-pro.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'monokai-pro*',
	once = true,
	callback = function()
		require('monokai-pro').setup({
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
		})
	end,
})
