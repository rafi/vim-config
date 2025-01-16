return {

	-- Underlines word under cursor
	{
		'itchyny/vim-cursorword',
		event = 'FileType',
		init = function()
			vim.g.cursorword = 0
		end,
		config = function()
			local augroup = vim.api.nvim_create_augroup('rafi.cursorword', {})
			vim.api.nvim_create_autocmd('FileType', {
				group = augroup,
				pattern = {
					'conf',
					'dosini',
					'json',
					'markdown',
					'nginx',
					'text',
					'yaml',
				},
				callback = function()
					if vim.wo.diff or vim.wo.previewwindow then
						vim.b.cursorword = 0
					else
						vim.b.cursorword = 1
					end
				end,
			})
			vim.api.nvim_create_autocmd('InsertEnter', {
				group = augroup,
				callback = function()
					if vim.b['cursorword'] == 1 then
						vim.b['cursorword'] = 0
					end
				end,
			})
			vim.api.nvim_create_autocmd('InsertLeave', {
				group = augroup,
				callback = function()
					if vim.b['cursorword'] == 0 then
						vim.b['cursorword'] = 1
					end
				end,
			})
		end,
	},
}
