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
		-- Not all LSP servers add brackets when completing a function.
		-- To better deal with this, LazyVim adds a custom option to cmp,
		-- that you can configure. For example:
		--
		-- ```lua
		-- opts = {
		--   auto_brackets = { "python" }
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
			local cmp = require('cmp')
			local Kind = cmp.lsp.CompletionItemKind
			cmp.setup(opts)
			cmp.event:on('confirm_done', function(event)
				if not vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
					return
				end
				local entry = event.entry
				local item = entry:get_completion_item()
				if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) and item.insertTextFormat ~= 2 then
					local cursor = vim.api.nvim_win_get_cursor(0)
					local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] + 1, {})[1]
					if prev_char ~= '(' and prev_char ~= ')' then
						local keys =
							vim.api.nvim_replace_termcodes('()<left>', false, false, true)
						vim.api.nvim_feedkeys(keys, 'i', true)
					end
				end
			end)
		end,
	},

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
					table.insert(opts.sources, { name = 'luasnip', keyword_length = 2 })
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

			if not LazyVim.has('nvim-cmp') then
				-- Insert `(` after function or method item selection.
				local cmp_autopairs = require('nvim-autopairs.completion.cmp')
				require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
			end
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
		'JoosepAlviste/nvim-ts-context-commentstring',
		opts = {
			enable = true,
			enable_autocmd = false,
		},
	},

	-----------------------------------------------------------------------------
	-- Powerful line and block-wise commenting
	{
		'numToStr/Comment.nvim',
		-- stylua: ignore
		event = 'VeryLazy',
		dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
		keys = {
			{ '<Leader>v', '<Plug>(comment_toggle_linewise_current)', mode = 'n', desc = 'Comment' },
			{ '<Leader>v', '<Plug>(comment_toggle_linewise_visual)', mode = 'x', desc = 'Comment' },
			{ '<Leader>V', '<Plug>(comment_toggle_blockwise_current)', mode = 'n', desc = 'Comment' },
			{ '<Leader>V', '<Plug>(comment_toggle_blockwise_visual)', mode = 'x', desc = 'Comment' },
		},
		opts = function(_, opts)
			local ok, tcc = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
			if ok then
				opts.pre_hook = tcc.create_pre_hook()
			end
		end
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
