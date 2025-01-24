return {

	-----------------------------------------------------------------------------
	-- Git client
	{
		'tpope/vim-fugitive',
		cmd = { 'G', 'Git', 'Gfetch', 'Gpush', 'Gclog', 'Gdiffsplit' },
		keys = {
			{ '<leader>gd', '<cmd>Gdiffsplit<CR>', desc = 'Git diff' },
			{ '<leader>gb', '<cmd>Git blame<CR>', desc = 'Git blame' },
		},
		config = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi.fugitive', {}),
				pattern = 'fugitiveblame',
				callback = function()
					vim.schedule(function()
						vim.cmd.normal('A')
					end)
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Git commit browser
	{
		'junegunn/gv.vim',
		dependencies = { 'tpope/vim-fugitive' },
		cmd = 'GV',
		keys = {
			{ '<leader>gl', '<cmd>GV<CR>', desc = 'Git log viewer' },
		},
	},
}
