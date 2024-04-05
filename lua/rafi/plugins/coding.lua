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
			-- nvim-cmp source for tmux
			'andersevenrud/cmp-tmux',
		},
		opts = function()
			vim.api.nvim_set_hl(
				0,
				'CmpGhostText',
				{ link = 'Comment', default = true }
			)
			local cmp = require('cmp')
			local defaults = require('cmp.config.default')()

			return {
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
					{
						name = 'tmux',
						priority = 10,
						keyword_length = 3,
						option = { all_panes = true, label = 'tmux' },
					},
				}),
				mapping = cmp.mapping.preset.insert({
					-- <CR> accepts currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					['<CR>'] = cmp.mapping.confirm({ select = false }),
					['<S-CR>'] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}),
					['<C-Space>'] = cmp.mapping.complete(),
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
		---@param opts cmp.ConfigSchema
		config = function(_, opts)
			for _, source in ipairs(opts.sources) do
				source.group_index = source.group_index or 1
			end
			require('cmp').setup(opts)
		end,
	},

	-----------------------------------------------------------------------------
	-- Snippet Engine written in Lua
	{
		'L3MON4D3/LuaSnip',
		event = 'InsertEnter',
		build = (not jit.os:find('Windows'))
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
			{
				'nvim-cmp',
				dependencies = {
					{ 'saadparwaiz1/cmp_luasnip' },
				},
				opts = function(_, opts)
					opts.snippet = {
						expand = function(args)
							require('luasnip').lsp_expand(args.body)
						end,
					}
					table.insert(opts.sources, { name = 'luasnip', keyword_length = 2 })

					local Util = require('rafi.util')
					local behavior = { behavior = require('cmp').SelectBehavior.Select }
					opts.mapping['<Tab>'] = Util.cmp.luasnip_supertab(behavior)
					opts.mapping['<S-Tab>'] = Util.cmp.luasnip_shift_supertab(behavior)
					opts.mapping['<C-j>'] = Util.cmp.luasnip_jump_forward()
					opts.mapping['<C-b>'] = Util.cmp.luasnip_jump_backward()
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
					local Util = require('lazy.core.util')
					vim.g.autopairs_disable = not vim.g.autopairs_disable
					if vim.g.autopairs_disable then
						require('nvim-autopairs').disable()
						Util.warn('Disabled auto pairs', { title = 'Option' })
					else
						require('nvim-autopairs').enable()
						Util.info('Enabled auto pairs', { title = 'Option' })
					end
				end,
				desc = 'Toggle auto pairs',
			},
		},
		config = function(_, opts)
			local autopairs = require('nvim-autopairs')
			autopairs.setup(opts)

			if not LazyVim.has('nvim-cmp') then
				-- Insert `(` after function or method item selection.
				local cmp_autopairs = require('nvim-autopairs.completion.cmp')
				require('cmp').event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end
		end
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
	-- Set the commentstring based on the cursor location
	{
		'JoosepAlviste/nvim-ts-context-commentstring',
		opts = {
			enable = true,
			enable_autocmd = false,
		},
	},

	-----------------------------------------------------------------------------
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
	-- Extend and create `a`/`i` textobjects
	{
		'echasnovski/mini.ai',
		event = 'VeryLazy',
		opts = function()
			local ai = require('mini.ai')
			return {
				n_lines = 500,
				-- stylua: ignore
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { '@block.outer', '@conditional.outer', '@loop.outer' },
						i = { '@block.inner', '@conditional.inner', '@loop.inner' },
					}, {}),
					f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
					c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
					t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
				},
			}
		end,
		config = function(_, opts)
			require('mini.ai').setup(opts)

			-- register all text objects with which-key
			LazyVim.on_load('which-key.nvim', function()
				---@type table<string, string|table>
				local i = {
					[' '] = 'Whitespace',
					['"'] = 'Balanced "',
					["'"] = "Balanced '",
					['`'] = 'Balanced `',
					['('] = 'Balanced (',
					[')'] = 'Balanced ) including white-space',
					['>'] = 'Balanced > including white-space',
					['<lt>'] = 'Balanced <',
					[']'] = 'Balanced ] including white-space',
					['['] = 'Balanced [',
					['}'] = 'Balanced } including white-space',
					['{'] = 'Balanced {',
					['?'] = 'User Prompt',
					_ = 'Underscore',
					a = 'Argument',
					b = 'Balanced ), ], }',
					c = 'Class',
					f = 'Function',
					o = 'Block, conditional, loop',
					q = 'Quote `, ", \'',
					t = 'Tag',
				}
				local a = vim.deepcopy(i) --[[@as table]]
				for k, v in pairs(a) do
					a[k] = v:gsub(' including.*', '')
				end

				local ic = vim.deepcopy(i)
				local ac = vim.deepcopy(a)
				for key, name in pairs({ n = 'Next', l = 'Last' }) do
					i[key] = vim.tbl_extend(
						'force',
						{ name = 'Inside ' .. name .. ' textobject' },
						ic
					)
					a[key] = vim.tbl_extend(
						'force',
						{ name = 'Around ' .. name .. ' textobject' },
						ac
					)
				end
				require('which-key').register({
					mode = { 'o', 'x' },
					i = i,
					a = a,
				})
			end)
		end,
	},
}
