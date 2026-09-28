-- Clean, dark Neovim theme

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/folke/tokyonight.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'tokyonight*',
	once = true,
	callback = function()
		require('tokyonight').setup({ style = 'moon' })
	end,
})
