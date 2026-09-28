-- High-contrast, futuristic & vibrant colorscheme

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/scottmckendry/cyberdream.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'cyberdream*',
	once = true,
	callback = function()
		require('cyberdream').setup({
			transparent = true,
			italic_comments = true,
			hide_fillchars = false,
			borderless_telescope = true,
			terminal_colors = true,
		})
	end,
})
