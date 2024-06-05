-- Plugins: Coding
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Completion plugin for neovim written in Lua
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
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
			local Util = require('rafi.util')

			return {
				-- configure any filetype to auto add brackets
				auto_brackets = { 'python' },
				view = {
					entries = { follow_cursor = true },
				},
				sorting = defaults.sorting,
				experimental = {
					ghost_text = {
						hl_group = 'Comment',
					},
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp', priority = 50 },
					{ name = 'path', priority = 40 },
				}, {
					{ name = 'buffer', priority = 50, keyword_length = 3 },
					{ name = 'emoji', insert = true, priority = 20 },
				}),
				mapping = cmp.mapping.preset.insert({
					-- <CR> accepts currently selected item.
					['<CR>'] = LazyVim.cmp.confirm(),
					-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					['<S-CR>'] = LazyVim.cmp.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
					}),
					['<C-Space>'] = cmp.mapping.complete(),
					['<Tab>'] = Util.cmp.supertab({
						behavior = require('cmp').SelectBehavior.Select,
					}),
					['<S-Tab>'] = Util.cmp.supertab_shift({
						behavior = require('cmp').SelectBehavior.Select,
					}),
					['<C-j>'] = Util.cmp.snippet_jump_forward(),
					['<C-k>'] = Util.cmp.snippet_jump_backward(),
					['<C-n>'] = cmp.mapping.select_next_item({
						behavior = cmp.SelectBehavior.Insert,
					}),
					['<C-p>'] = cmp.mapping.select_prev_item({
						behavior = cmp.SelectBehavior.Insert,
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
						local icons = require('lazyvim.config').icons
						if entry.source.name == 'git' then
							item.kind = icons.misc.git
						else
							local icon = icons.kinds[item.kind]
							if icon ~= nil then
								item.kind = icon .. ' ' .. item.kind
							end
						end
						return item
					end,
				},
			}
		end,
		---@param opts cmp.ConfigSchema | {auto_brackets?: string[]}
		config = function(_, opts)
			for _, source in ipairs(opts.sources) do
				source.group_index = source.group_index or 1
			end

			local parse = require('cmp.utils.snippet').parse
			---@diagnostic disable-next-line: duplicate-set-field
			require('cmp.utils.snippet').parse = function(input)
				local ok, ret = pcall(parse, input)
				if ok then
					return ret
				end
				return LazyVim.cmp.snippet_preview(input)
			end

			local cmp = require('cmp')
			cmp.setup(opts)
			cmp.event:on('confirm_done', function(event)
				if vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
					LazyVim.cmp.auto_brackets(event.entry)
				end
			end)
			cmp.event:on('menu_opened', function(event)
				LazyVim.cmp.add_missing_snippet_docs(event.window)
			end)
		end,
	},

	-----------------------------------------------------------------------------
	-- Native snippets
	vim.fn.has('nvim-0.10') == 1
			and {
				'nvim-cmp',
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
					table.insert(opts.sources, { name = 'snippets' })
				end,
			}
		or {
			import = 'rafi.plugins.extras.coding.luasnip',
			enabled = vim.fn.has('nvim-0.10') == 0,
		},

	-----------------------------------------------------------------------------
	-- Powerful auto-pair plugin with multiple characters support
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		opts = {
			disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
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
		enabled = vim.fn.has('nvim-0.10') == 1,
		opts = {},
	},
	{
		import = 'lazyvim.plugins.extras.coding.mini-comment',
		enabled = vim.fn.has('nvim-0.10') == 0,
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
			LazyVim.on_load('which-key.nvim', function()
				vim.schedule(LazyVim.mini.ai_whichkey)
			end)
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
	},
}
