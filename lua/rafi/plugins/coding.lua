-- Plugins: Coding
-- https://github.com/rafi/vim-config

return {

	{
		import = 'rafi.plugins.extras.coding.nvim-cmp',
		enabled = function()
			return LazyVim.cmp_engine() == 'nvim-cmp'
		end,
	},
	{
		import = 'lazyvim.plugins.extras.coding.blink',
		enabled = function()
			return LazyVim.cmp_engine() == 'blink.cmp'
		end,
	},

	-----------------------------------------------------------------------------
	-- Powerful auto-pair plugin with multiple characters support
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		opts = {
			map_cr = false,
			disable_in_visualblock = true,
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
	-- Properly configures LuaLS and lazily update your workspace libraries
	{
		'folke/lazydev.nvim',
		ft = 'lua',
		cmd = 'LazyDev',
		opts = {
			library = {
				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
				{ path = 'LazyVim', words = { 'LazyVim' } },
				{ path = 'snacks.nvim', words = { 'Snacks' } },
				{ path = 'lazy.nvim', words = { 'LazyVim' } },
			},
		},
	},
}
