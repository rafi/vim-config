-- Plugins: Coding
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	{ 'sbdchd/neoformat', cmd = 'Neoformat' },

	-----------------------------------------------------------------------------
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-emoji',
			'saadparwaiz1/cmp_luasnip',
			'andersevenrud/cmp-tmux',
		},
		opts = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			local function has_words_before()
				if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
					return false
				end
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
			end

			return {
				preselect = cmp.PreselectMode.None,
				experimental = {
					ghost_text = {
						hl_group = 'LspCodeLens',
					},
				},
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp', priority = 100 },
					{ name = 'path', priority = 90 },
					{ name = 'luasnip', priority = 80 },
					{ name = 'emoji', insert = true, priority = 70 },
				}, {
					{ name = 'buffer', priority = 50, keyword_length = 1 },
					{ name = 'tmux', priority = 10, option = { all_panes = true }},
				}),
				mapping = cmp.mapping.preset.insert({
					-- <CR> accepts currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					['<CR>'] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ select = false })
							else
								fallback()
							end
						end,
						s = cmp.mapping.confirm({
							select = true,
							behavior = cmp.ConfirmBehavior.Replace,
						}),
						c = cmp.mapping.confirm({ select = true }),
					}),
					['<S-CR>'] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-d>'] = cmp.mapping.select_next_item({ count = 5 }),
					['<C-u>'] = cmp.mapping.select_prev_item({ count = 5 }),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-c>'] = function(fallback)
						cmp.close()
						fallback()
					end,
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.jumpable(1) then
							luasnip.jump(1)
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				}),
				formatting = {
					format = function(_, vim_item)
						-- Prepend with a fancy icon from config lua/rafi/config/init.lua
						local symbol = require('rafi.config').icons.kinds[vim_item.kind]
						if symbol ~= nil then
							vim_item.kind = symbol .. ' ' .. vim_item.kind
						end
						return vim_item
					end,
				},
			}
		end,
	},

	-----------------------------------------------------------------------------
	{
		'L3MON4D3/LuaSnip',
		event = 'InsertEnter',
		dependencies = { 'rafamadriz/friendly-snippets' },
		build = (not jit.os:find('Windows')) and 'make install_jsregexp' or nil,
		keys = {
			{
				'<C-l>',
				function() require('luasnip').expand_or_jump() end,
				mode = { 'i', 's' }
			}
		},
		opts = {
			-- Don't store snippet history for less overhead
			history = false,
			-- Event on which to check for exiting a snippet's region
			region_check_events = 'InsertEnter',
			delete_check_events = 'InsertLeave',
			ft_func = function()
				return vim.split(vim.bo.filetype, '.', { plain = true })
			end,
		},
		config = function(_, opts)
			require('luasnip').setup(opts)
			require('luasnip.loaders.from_vscode').lazy_load()
			require('luasnip.loaders.from_lua').load({ paths = './snippets' })
			vim.api.nvim_create_user_command('LuaSnipEdit', function()
				require('luasnip.loaders.from_lua').edit_snippet_files()
			end, {})
		end
	},

	-----------------------------------------------------------------------------
	{
		'ziontee113/SnippetGenie',
		event = 'InsertEnter',
		dependencies = 'L3MON4D3/LuaSnip',
		opts = {
			snippets_directory = vim.fn.stdpath('config') .. '/snippets',
		},
	},

	-----------------------------------------------------------------------------
	{
		'echasnovski/mini.pairs',
		event = 'VeryLazy',
		main = 'mini.pairs',
		config = true,
	},

	-----------------------------------------------------------------------------
	{
		'echasnovski/mini.surround',
		main = 'mini.surround',
		keys = function(_, keys)
			-- Populate the keys based on the user's options
			local plugin = require('lazy.core.config').spec.plugins['mini.surround']
			local opts = require('lazy.core.plugin').values(plugin, 'opts', false)
			local mappings = {
				{ opts.mappings.add, desc = 'Add surrounding', mode = { 'n', 'x' } },
				{ opts.mappings.delete, desc = 'Delete surrounding' },
				{ opts.mappings.find, desc = 'Find right surrounding' },
				{ opts.mappings.find_left, desc = 'Find left surrounding' },
				{ opts.mappings.highlight, desc = 'Highlight surrounding' },
				{ opts.mappings.replace, desc = 'Replace surrounding' },
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
	{ 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },
	{
		'echasnovski/mini.comment',
		event = 'VeryLazy',
		main = 'mini.comment',
		keys = {
			{ '<Leader>v', 'gcc', remap = true, silent = true, mode = 'n' },
			{ '<Leader>v', 'gc', remap = true, silent = true, mode = 'x' },
		},
		opts = {
			hooks = {
				pre = function()
					require('ts_context_commentstring.internal').update_commentstring({})
				end,
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'echasnovski/mini.trailspace',
		event = { 'BufReadPost', 'BufNewFile' },
		main = 'mini.trailspace',
		config = true,
	},

	-----------------------------------------------------------------------------
	{
		'echasnovski/mini.bracketed',
		event = 'BufReadPost',
		main = 'mini.bracketed',
		opts = {
			treesitter = { suffix = '' },
		},
	},

	-----------------------------------------------------------------------------
	{
		'echasnovski/mini.ai',
		event = 'VeryLazy',
		main = 'mini.ai',
		dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
		opts = function()
			local ai = require('mini.ai')
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { '@block.outer', '@conditional.outer', '@loop.outer' },
						i = { '@block.inner', '@conditional.inner', '@loop.inner' },
					}, {}),
					f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
					c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
				},
			}
		end,
	},

	-----------------------------------------------------------------------------
	{
		'echasnovski/mini.splitjoin',
		main = 'mini.splitjoin',
		keys = {
			{
				'sj',
				'<cmd>lua MiniSplitjoin.join()<CR>',
				mode = { 'n', 'x' },
				desc = 'Join arguments'
			},
			{
				'sk',
				'<cmd>lua MiniSplitjoin.split()<CR>',
				mode = { 'n', 'x' },
				desc = 'Split arguments'
			},
		},
		opts = {
			mappings = { toggle = '' },
		},
	},

	-----------------------------------------------------------------------------
	{
		'AndrewRadev/linediff.vim',
		cmd = { 'Linediff', 'LinediffAdd' },
		keys = {
			{ '<Leader>mdf', ':Linediff<CR>', mode = 'x', desc = 'Line diff' },
			{ '<Leader>mda', ':LinediffAdd<CR>', mode = 'x', desc = 'Line diff add' },
			{ '<Leader>mds', '<cmd>LinediffShow<CR>', desc = 'Line diff show' },
			{ '<Leader>mdr', '<cmd>LinediffReset<CR>', desc = 'Line diff reset' },
		}
	},

	-----------------------------------------------------------------------------
	{
		'AndrewRadev/dsf.vim',
		keys = {
			{ 'dsf', '<Plug>DsfDelete', noremap = true, desc = 'Delete Surrounding Function' },
			{ 'csf', '<Plug>DsfChange', noremap = true, desc = 'Change Surrounding Function' },
		},
		init = function()
			vim.g.dsf_no_mappings = 1
		end
	},

}
