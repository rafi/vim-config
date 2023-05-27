return {
	{
		'pechorin/any-jump.vim',
		cmd = { 'AnyJump', 'AnyJumpVisual' },
		keys = {
			{ '<leader>ii', '<cmd>AnyJump<CR>', desc = 'Any Jump' },
			{ '<leader>ii', '<cmd>AnyJumpVisual<CR>', mode = 'x', desc = 'Any Jump' },
			{ '<leader>ib', '<cmd>AnyJumpBack<CR>', desc = 'Any Jump Back' },
			{ '<leader>il', '<cmd>AnyJumpLastResults<CR>', desc = 'Any Jump Resume' },
		},
		init = function()
			vim.g.any_jump_disable_default_keybindings = 1
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_any-jump', {}),
				pattern = 'any-jump',
				callback = function()
					vim.opt.cursorline = true
				end,
			})
		end,
	},
}
