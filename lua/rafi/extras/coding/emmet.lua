return {

	-- Provides support for expanding abbreviations alá emmet
	{
		'mattn/emmet-vim',
		ft = { 'html', 'css', 'vue', 'javascript', 'javascriptreact', 'svelte' },
		init = function()
			vim.g.user_emmet_mode = 'i'
			vim.g.user_emmet_install_global = 0
			vim.g.user_emmet_install_command = 0
			vim.g.user_emmet_complete_tag = 0
		end,
		config = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi.emmet', {}),
				pattern = {
					'css',
					'html',
					'javascript',
					'javascriptreact',
					'svelte',
					'vue',
				},
				callback = function()
					vim.cmd([[
						EmmetInstall
						imap <silent><buffer> <C-y> <Plug>(emmet-expand-abbr)
					]])
				end,
			})
		end,
	},
}
