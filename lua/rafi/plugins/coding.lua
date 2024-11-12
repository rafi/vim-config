-- Plugins: Coding
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Completion plugin for neovim written in Lua
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		main = 'lazyvim.util.cmp',
		dependencies = {
			-- nvim-cmp source for neovim builtin LSP client
			'hrsh7th/cmp-nvim-lsp',
			-- nvim-cmp source for buffer words
			'hrsh7th/cmp-buffer',
			-- nvim-cmp source for path
			'hrsh7th/cmp-path',
			-- nvim-cmp source for emoji
			'hrsh7th/cmp-emoji',
		},
		-- Not all LSP servers add brackets when completing a function.
		-- To better deal with this, LazyVim adds a custom option to cmp,
		-- that you can configure. For example:
		--
		-- ```lua
		-- opts = {
		--   auto_brackets = { 'python' }
		-- }
		-- ```

		opts = function()
			vim.api.nvim_set_hl(
				0,
				'CmpGhostText',
				{ link = 'Comment', default = true }
			)
			local cmp = require('cmp')
			local defaults = require('cmp.config.default')()
			local auto_select = false
			local Util = require('rafi.util')

			return {
				-- configure any filetype to auto add brackets
				auto_brackets = { 'python' },
				completion = {
					completeopt = 'menu,menuone,noinsert'
						.. (auto_select and '' or ',noselect'),
				},
				preselect = auto_select and cmp.PreselectMode.Item
					or cmp.PreselectMode.None,
				view = {
					entries = { follow_cursor = true },
				},
				sorting = defaults.sorting,
				experimental = {
					-- Only show ghost text when we show ai completions
					ghost_text = vim.g.ai_cmp and {
						hl_group = 'CmpGhostText',
					} or false,
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp', priority = 50 },
					{ name = 'path', priority = 40 },
				}, {
					{ name = 'buffer', priority = 50, keyword_length = 3 },
					{ name = 'emoji', insert = true, priority = 20 },
				}),
				mapping = cmp.mapping.preset.insert({
					['<CR>'] = LazyVim.cmp.confirm({ select = auto_select }),
					['<C-y>'] = LazyVim.cmp.confirm({ select = true }),
					['<S-CR>'] = LazyVim.cmp.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
					}),
					['<C-CR>'] = function(fallback)
						cmp.abort()
						fallback()
					end,
					['<C-Space>'] = cmp.mapping.complete(),
					['<Tab>'] = Util.cmp.supertab({
						behavior = require('cmp').SelectBehavior.Select,
					}),
					['<S-Tab>'] = Util.cmp.supertab_shift({
						behavior = require('cmp').SelectBehavior.Select,
					}),
					['<C-d>'] = cmp.mapping.select_next_item({ count = 5 }),
					['<C-u>'] = cmp.mapping.select_prev_item({ count = 5 }),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-c>'] = function(fallback)
						cmp.close()
						fallback()
					end,
					['<C-e>'] = cmp.mapping(function()
						if cmp.visible() then
							cmp.abort()
						else
							cmp.complete()
						end
					end),
				}),
				formatting = {
					format = function(entry, item)
						-- Prepend with a fancy icon from config.
						local icons = LazyVim.config.icons
						if entry.source.name == 'git' then
							item.kind = icons.misc.git
						else
							local icon = icons.kinds[item.kind]
							if icon ~= nil then
								item.kind = icon .. item.kind
							end
						end
						local widths = {
							abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
							menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
						}

						for key, width in pairs(widths) do
							if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
								item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. '…'
							end
						end
						return item
					end,
				},
			}
		end,
	},

	-----------------------------------------------------------------------------
	-- Native snippets
	{
		'nvim-cmp',
		optional = true,
		dependencies = {
			{
				'garymjr/nvim-snippets',
				opts = {
					friendly_snippets = true,
				},
				dependencies = {
					-- Preconfigured snippets for different languages
					'rafamadriz/friendly-snippets',
				},
			},
		},
		opts = function(_, opts)
			opts.snippet = {
				expand = function(item)
					return LazyVim.cmp.expand(item.body)
				end,
			}
			if LazyVim.has('nvim-snippets') then
				table.insert(opts.sources, { name = 'snippets' })
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- Powerful auto-pair plugin with multiple characters support
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		opts = {
			map_cr = false,
			avoid_move_to_end = true, -- stay for direct end_key use
			disable_filetype = { 'TelescopePrompt', 'grug-far', 'spectre_panel' },
		},
		keys = {
			{
				'<leader>up',
				function()
					vim.g.autopairs_disable = not vim.g.autopairs_disable
					if vim.g.autopairs_disable then
						require('nvim-autopairs').disable()
						LazyVim.warn('Disabled auto pairs', { title = 'Option' })
					else
						require('nvim-autopairs').enable()
						LazyVim.info('Enabled auto pairs', { title = 'Option' })
					end
				end,
				desc = 'Toggle auto pairs',
			},
		},
		config = function(_, opts)
			local autopairs = require('nvim-autopairs')
			autopairs.setup(opts)
		end,
	},

	-----------------------------------------------------------------------------
	-- Fast and feature-rich surround actions
	{
		'echasnovski/mini.surround',
		-- stylua: ignore
		keys = function(_, keys)
			-- Populate the keys based on the user's options
			local plugin = require('lazy.core.config').spec.plugins['mini.surround']
			local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
			local mappings = {
				{ opts.mappings.add, desc = 'Add Surrounding', mode = { 'n', 'v' } },
				{ opts.mappings.delete, desc = 'Delete Surrounding' },
				{ opts.mappings.find, desc = 'Find Right Surrounding' },
				{ opts.mappings.find_left, desc = 'Find Left Surrounding' },
				{ opts.mappings.highlight, desc = 'Highlight Surrounding' },
				{ opts.mappings.replace, desc = 'Replace Surrounding' },
				{ opts.mappings.update_n_lines, desc = 'Update `MiniSurround.config.n_lines`' },
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			mappings = {
				add = 'sa', -- Add surrounding in Normal and Visual modes
				delete = 'ds', -- Delete surrounding
				find = 'gzf', -- Find surrounding (to the right)
				find_left = 'gzF', -- Find surrounding (to the left)
				highlight = 'gzh', -- Highlight surrounding
				replace = 'cs', -- Replace surrounding
				update_n_lines = 'gzn', -- Update `n_lines`
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Set the commentstring based on the cursor location
	{
		'folke/ts-comments.nvim',
		event = 'VeryLazy',
		opts = {},
	},

	-----------------------------------------------------------------------------
	-- Powerful line and block-wise commenting
	{
		'numToStr/Comment.nvim',
		dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
		-- stylua: ignore
		keys = {
			{ '<Leader>V', '<Plug>(comment_toggle_blockwise_current)', mode = 'n', desc = 'Comment' },
			{ '<Leader>V', '<Plug>(comment_toggle_blockwise_visual)', mode = 'x', desc = 'Comment' },
		},
		opts = function(_, opts)
			local ok, tcc =
				pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
			if ok then
				opts.pre_hook = tcc.create_pre_hook()
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- Split and join arguments
	{
		'echasnovski/mini.splitjoin',
		-- stylua: ignore
		keys = {
			{ 'sj', '<cmd>lua MiniSplitjoin.join()<CR>', mode = { 'n', 'x' }, desc = 'Join arguments' },
			{ 'sk', '<cmd>lua MiniSplitjoin.split()<CR>', mode = { 'n', 'x' }, desc = 'Split arguments' },
		},
		opts = {
			mappings = { toggle = '' },
		},
	},

	-----------------------------------------------------------------------------
	-- Trailing whitespace highlight and remove
	{
		'echasnovski/mini.trailspace',
		event = { 'BufReadPost', 'BufNewFile' },
		-- stylua: ignore
		keys = {
			{ '<Leader>cw', '<cmd>lua MiniTrailspace.trim()<CR>', desc = 'Erase Whitespace' },
		},
		opts = {},
	},

	-----------------------------------------------------------------------------
	-- Perform diffs on blocks of code
	{
		'AndrewRadev/linediff.vim',
		cmd = { 'Linediff', 'LinediffAdd' },
		keys = {
			{ '<Leader>mdf', ':Linediff<CR>', mode = 'x', desc = 'Line diff' },
			{ '<Leader>mda', ':LinediffAdd<CR>', mode = 'x', desc = 'Line diff add' },
			{ '<Leader>mds', '<cmd>LinediffShow<CR>', desc = 'Line diff show' },
			{ '<Leader>mdr', '<cmd>LinediffReset<CR>', desc = 'Line diff reset' },
		},
	},

	-----------------------------------------------------------------------------
	-- Delete surrounding function call
	{
		'AndrewRadev/dsf.vim',
		-- stylua: ignore
		keys = {
			{ 'dsf', '<Plug>DsfDelete', noremap = true, desc = 'Delete Surrounding Function' },
			{ 'csf', '<Plug>DsfChange', noremap = true, desc = 'Change Surrounding Function' },
		},
		init = function()
			vim.g.dsf_no_mappings = 1
		end,
	},

	-----------------------------------------------------------------------------
	-- Extend and create `a`/`i` text-objects
	{
		'echasnovski/mini.ai',
		event = 'VeryLazy',
		opts = function()
			local ai = require('mini.ai')
			return {
				n_lines = 500,
				-- stylua: ignore
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { '@block.outer', '@conditional.outer', '@loop.outer' },
						i = { '@block.inner', '@conditional.inner', '@loop.inner' },
					}),
					f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
					c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
					t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
					d = { '%f[%d]%d+' }, -- digits
					e = { -- Word with case
						{ '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
						'^().*()$',
					},
					i = LazyVim.mini.ai_indent, -- indent
					g = LazyVim.mini.ai_buffer, -- buffer
					u = ai.gen_spec.function_call(), -- u for Usage
					U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
				},
			}
		end,
		config = function(_, opts)
			require('mini.ai').setup(opts)
			LazyVim.on_load('which-key.nvim', function()
				vim.schedule(function()
					LazyVim.mini.ai_whichkey(opts)
				end)
			end)
		end,
	},

	-----------------------------------------------------------------------------
	{
		'folke/lazydev.nvim',
		ft = 'lua',
		cmd = 'LazyDev',
		opts = {
			library = {
				{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
				{ path = 'LazyVim', words = { 'LazyVim' } },
				{ path = 'snacks.nvim', words = { 'Snacks' } },
				{ path = 'lazy.nvim', words = { 'LazyVim' } },
			},
		},
	},
	-- Manage libuv types with lazy. Plugin will never be loaded
	{ 'Bilal2453/luvit-meta', lazy = true },
	-- Add lazydev source to cmp
	{
		'hrsh7th/nvim-cmp',
		optional = true,
		opts = function(_, opts)
			table.insert(opts.sources, { name = 'lazydev', group_index = 0 })
		end,
	},
}
