-- Pink-cyan-lavender colorscheme, where green never reaches code

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/marekh19/meowsoot.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'meowsoot*',
	once = true,
	callback = function()
		require('meowsoot').setup({
			style = 'night', -- 'night' (dark) | 'dawn' (light)
			transparent = false,
		})
	end,
})
