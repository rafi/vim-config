return {

	-----------------------------------------------------------------------------
	-- Snippet Engine written in Lua
	{
		'L3MON4D3/LuaSnip',
		event = 'InsertEnter',
		build = (not LazyVim.is_win())
				and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
			or nil,
		dependencies = {
			-- Preconfigured snippets for different languages
			{
				'rafamadriz/friendly-snippets',
				config = function()
					require('luasnip.loaders.from_vscode').lazy_load()
					require('luasnip.loaders.from_lua').load({ paths = { './snippets' } })
				end,
			},
			-- Adds luasnip source to nvim-cmp.
			{
				'nvim-cmp',
				dependencies = {
					-- Luasnip completion source for nvim-cmp
					'saadparwaiz1/cmp_luasnip',
				},
				opts = function(_, opts)
					opts.snippet = {
						expand = function(args)
							require('luasnip').lsp_expand(args.body)
						end,
					}
					table.insert(opts.sources, { name = 'luasnip' })
				end,
			},
		},
		-- stylua: ignore
		keys = {
			{ '<C-l>', function() require('luasnip').expand_or_jump() end, mode = { 'i', 's' } },
		},
		opts = {
			history = true,
			delete_check_events = 'TextChanged',
			-- ft_func = function()
			-- 	return vim.split(vim.bo.filetype, '.', { plain = true })
			-- end,
		},
		config = function(_, opts)
			require('luasnip').setup(opts)
			vim.api.nvim_create_user_command('LuaSnipEdit', function()
				require('luasnip.loaders').edit_snippet_files()
			end, {})
		end,
	},

	{
		'garymjr/nvim-snippets',
		enabled = false,
	},
}
