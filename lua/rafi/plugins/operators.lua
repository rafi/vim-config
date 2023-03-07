-- Plugins: Operators
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	{
		'echasnovski/mini.ai',
		event = 'VeryLazy',
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
		config = function(_, opts)
			require('mini.ai').setup(opts)
		end,
	},

	-----------------------------------------------------------------------------
	{
		'mfussenegger/nvim-treehopper',
		keys = {
			{ 'am', function() require('tsht').nodes() end, mode = { 'o', 'x' }},
		},
	},

	-----------------------------------------------------------------------------
	{
		'AndrewRadev/sideways.vim',
		cmd = {
			'SidewaysLeft',
			'SidewaysRight',
			'SidewaysJumpLeft',
			'SidewaysJumpRight',
		},
		keys = {
			{ '<,', '<cmd>SidewaysLeft<CR>', noremap = true, desc = 'Swap Left Argument' },
			{ '>,', '<cmd>SidewaysRight<CR>', noremap = true, desc = 'Swap Right Argument' },
			{ '[,', '<cmd>SidewaysJumpLeft<CR>', noremap = true, desc = 'Jump Left Argument' },
			{ '],', '<cmd>SidewaysJumpRight<CR>', noremap = true, desc = 'Jump Right Argument' },
			{ 'a,', '<Plug>SidewaysArgumentTextobjA', noremap = true, mode = { 'o', 'x' }},
			{ 'i,', '<Plug>SidewaysArgumentTextobjI', noremap = true, mode = { 'o', 'x' }},
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
		'AndrewRadev/splitjoin.vim',
		cmd = { 'SplitjoinJoin', 'SplitjoinSplit' },
		keys = {
			{ 'sj', '<cmd>SplitjoinJoin<CR>', noremap = true, desc = 'Join Arguments' },
			{ 'sk', '<cmd>SplitjoinSplit<CR>', noremap = true, desc = 'Split Arguments' },
		},
		init = function()
			vim.g.splitjoin_join_mapping = ''
			vim.g.splitjoin_split_mapping = ''
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_splitjoin', {}),
				pattern = 'go',
				callback = function()
					vim.b.splitjoin_trailing_comma = 1
				end
			})
		end
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
