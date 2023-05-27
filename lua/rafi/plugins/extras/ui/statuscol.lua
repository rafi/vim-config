return {
	{
		'luukvbaal/statuscol.nvim',
		event = 'BufReadPost',
		init = function()
			vim.opt_global.foldcolumn = '1'
		end,
		opts = function()
			local builtin = require('statuscol.builtin')
			return {
				setopt = true,
				relculright = true,
				segments = {
					{
						sign = { name = { '.*' }, maxwidth = 2, colwidth = 1, auto = true },
						click = 'v:lua.ScSa',
					},
					{ text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
					{ text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
				},
			}
		end,
	},
}
