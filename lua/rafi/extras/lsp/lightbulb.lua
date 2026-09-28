-- VSCode 💡 for neovim's built-in LSP

require('rafi.pack').on_event('LspAttach', function()
	vim.pack.add({ 'https://github.com/kosayoda/nvim-lightbulb' })
	require('nvim-lightbulb').setup({
		autocmd = { enabled = true },
		ignore = {
			clients = { 'null-ls' },
		},
	})
end)
