-- Highly accessible themes conforming with WCAG AAA color contrast

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/miikanissi/modus-themes.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'modus*',
	once = true,
	callback = function()
		require('modus-themes').setup({
			style = 'auto', -- auto, modus_operandi, modus_vivendi
			transparent = false,
			dim_inactive = false,
		})
	end,
})
