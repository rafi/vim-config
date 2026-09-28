-- Warm green theme

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/ribru17/bamboo.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'bamboo*',
	once = true,
	callback = function()
		require('bamboo').setup({})
	end,
})
