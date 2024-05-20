return {

	-- EditorConfig plugin written entirely in Vimscript
	{
		'sgur/vim-editorconfig',
		lazy = false,
		init = function()
			vim.g.editorconfig_verbose = 1
			vim.g.editorconfig_blacklist = {
				filetype = {
					'git.*',
					'fugitive',
					'help',
					'lsp-.*',
					'any-jump',
					'gina-.*',
				},
				pattern = { '\\.un~$' },
			}
		end,
	},
}
