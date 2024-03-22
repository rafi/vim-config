return {
	desc = 'Use native snippets instead of LuaSnip. Only works on Neovim >= 0.10!',

	{ 'L3MON4D3/LuaSnip', enabled = false },
	{ 'saadparwaiz1/cmp_luasnip', enabled = false },

	-----------------------------------------------------------------------------
	{
		'danymat/neogen',
		optional = true,
		opts = { snippet_engine = nil },
	},

	-----------------------------------------------------------------------------
	-- Allow vscode style snippets to be used with native neovim snippets
	{
		'garymjr/nvim-snippets',
		dependencies = {
			-- Preconfigured snippets for different languages
			'rafamadriz/friendly-snippets',
		},
		opts = {
			friendly_snippets = true,
		},
	},

	-----------------------------------------------------------------------------
	{
		'nvim-cmp',
		dependencies = { 'nvim-snippets' },
		opts = function(_, opts)
			opts = opts or {}
			opts.snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			}

			opts.sources = opts.sources or {}
			table.insert(opts.sources, { name = 'snippets', keyword_length = 2 })

			local cmp = require('cmp')
			opts.mapping = opts.mapping or {}
			opts.mapping['<Tab>'] = {
				i = function(fallback)
					local col = vim.fn.col('.') - 1
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					elseif vim.snippet.jumpable(1) then
						vim.snippet.jump(1)
					elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
						cmp.complete()
					else
						fallback()
					end
				end,
				s = function(fallback)
					if vim.snippet.jumpable(1) then
						vim.snippet.jump(1)
					else
						fallback()
					end
				end
			}

			opts.mapping['<S-Tab>'] = {
				i = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					elseif vim.snippet.jumpable(-1) then
						vim.snippet.jump(-1)
					else
						fallback()
					end
				end,
				s = function(fallback)
					if vim.snippet.jumpable(-1) then
						vim.snippet.jump(-1)
					else
						fallback()
					end
				end,
			}
		end,
	},
}
