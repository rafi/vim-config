-- Plugins: Coding
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Code completion
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/coding/blink.lua
	{
		'blink.cmp',
		optional = true,
		opts = {
			keymap = {
				['<C-j>'] = { 'select_next', 'fallback' },
				['<C-k>'] = { 'select_prev', 'fallback' },
				['<C-d>'] = { 'select_next', 'fallback' },
				['<C-u>'] = { 'select_prev', 'fallback' },
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Lightweight yet powerful formatter plugin
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/formatting.lua
	{
		'conform.nvim',
		-- stylua: ignore
		keys = {
			{ '<leader>cic', '<cmd>ConformInfo<CR>', silent = true, desc = 'Conform Info' },
		},
	},

	-----------------------------------------------------------------------------
	-- Asynchronous linter plugin
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/linting.lua
	{
		'nvim-lint',
		keys = {
			{
				'<leader>cin',
				function()
					vim.notify(vim.inspect(require('lint').linters[vim.bo.filetype]))
				end,
				silent = true,
				desc = 'Linter Info',
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Fast and feature-rich surround actions
	{ import = 'lazyvim.plugins.extras.coding.mini-surround' },
	{
		'mini.surround',
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
	-- Powerful line and block-wise commenting
	{
		'numToStr/Comment.nvim',
		dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
		-- stylua: ignore
		keys = {
			{ '<leader>V', '<Plug>(comment_toggle_blockwise_current)', mode = 'n', desc = 'Comment' },
			{ '<leader>V', '<Plug>(comment_toggle_blockwise_visual)', mode = 'x', desc = 'Comment' },
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
			{ '<leader>cw', '<cmd>lua MiniTrailspace.trim()<CR>', desc = 'Erase Whitespace' },
		},
		opts = {},
	},

	-----------------------------------------------------------------------------
	-- Perform diffs on blocks of code
	{
		'AndrewRadev/linediff.vim',
		cmd = { 'Linediff', 'LinediffAdd' },
		keys = {
			{ '<leader>mdf', ':Linediff<CR>', mode = 'x', desc = 'Line diff' },
			{ '<leader>mda', ':LinediffAdd<CR>', mode = 'x', desc = 'Line diff add' },
			{ '<leader>mds', '<cmd>LinediffShow<CR>', desc = 'Line diff show' },
			{ '<leader>mdr', '<cmd>LinediffReset<CR>', desc = 'Line diff reset' },
		},
	},
}
