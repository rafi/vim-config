-- Helm: helm-ls.nvim filetypes/ftplugin, and helm_ls language server

-- Eager: ftdetect must be sourced before files are read. Its setup() was
-- never called (conceal, indent hints and action highlight stay off).
vim.pack.add({ 'https://github.com/qvalentin/helm-ls.nvim' })

vim.filetype.add({
	pattern = {
		['.*/templates/.*%.ya?ml'] = 'helm',
		['.*/templates/.*%.tpl'] = 'helm',
	},
})

require('rafi.util.lang').add({ servers = { helm_ls = true } })
