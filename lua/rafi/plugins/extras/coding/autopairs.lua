return {
	{
		'windwp/nvim-autopairs',
		dependencies = 'hrsh7th/nvim-cmp',
		config = function()
			local autopairs = require('nvim-autopairs')
			autopairs.setup()

			-- Disable [ rule, it interferes with zk-nvim link completion.
			local cond = require('nvim-autopairs.conds')
			autopairs.get_rule('['):with_pair(cond.not_filetypes({ 'markdown' }))

			-- Insert `(` after function or method item selection.
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
		end,
	},
}
