if not vim.snippet then
	LazyVim.warn('Native snippets are only supported on Neovim >= 0.10.0')
	return {}
end

return {
	desc = 'Use native snippets instead of LuaSnip. Only works on Neovim >= 0.10!',

	{ 'L3MON4D3/LuaSnip', enabled = false },
	{ 'saadparwaiz1/cmp_luasnip', enabled = false },

	-----------------------------------------------------------------------------
	-- Use native snippet client instead of LuaSnip
	{
		'nvim-cmp',
		dependencies = {
			-- Preconfigured snippets for different languages
			{ 'rafamadriz/friendly-snippets' },
			-- Allow vscode style snippets to be used with native neovim snippets
			{ 'garymjr/nvim-snippets', opts = { friendly_snippets = true } },
		},
		opts = function(_, opts)
			opts = opts or {}
			opts.snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			}

			opts.sources = opts.sources or {}
			table.insert(opts.sources, { name = 'snippets', keyword_length = 2 })
		end,
	},

	-----------------------------------------------------------------------------
	{
		'danymat/neogen',
		optional = true,
		opts = { snippet_engine = nil },
	},

}
