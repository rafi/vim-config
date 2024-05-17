return {

	-- Annotation generator
	{
		'danymat/neogen',
		-- stylua: ignore
		keys = {
			{ '<leader>cg', function() require('neogen').generate({}) end, desc = 'Neogen Comment' },
		},
		opts = { snippet_engine = 'luasnip' },
	},
}
