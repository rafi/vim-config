return {
	{
		'Bekaboo/deadcolumn.nvim',
		event = 'BufReadPost',
		config = true,
		init = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_deadcolumn', {}),
				callback = function()
					if vim.bo.buftype ~= '' then
						vim.wo.colorcolumn = '0'
					end
				end
			})
		end
	},
}
