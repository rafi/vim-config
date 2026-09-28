-- Github's Neovim themes

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/projekt0n/github-nvim-theme' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'github_*',
	once = true,
	callback = function()
		require('github-theme').setup({})
	end,
})
