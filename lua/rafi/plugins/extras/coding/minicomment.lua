return {

	{ 'numToStr/Comment.nvim', enabled = false },

	-- Fast and familiar per-line commenting
	{
		'echasnovski/mini.comment',
		event = 'VeryLazy',
		dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
		-- stylua: ignore
		keys = {
			{ '<Leader>v', 'gcc', remap = true, silent = true, mode = 'n', desc = 'Comment' },
			{ '<Leader>v', 'gc', remap = true, silent = true, mode = 'x', desc = 'Comment' },
		},
		opts = {
			options = {
				custom_commentstring = function()
					return require('ts_context_commentstring.internal').calculate_commentstring()
						or vim.bo.commentstring
				end,
			},
		},
	},
}
