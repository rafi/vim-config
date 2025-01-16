-- rafi.plugins.extras.lang.tmux
--

LazyVim.on_very_lazy(function()
	vim.filetype.add({
		filename = { Tmuxfile = 'tmux' },
	})
end)

return {
	desc = 'Tmux syntax, navigator (<C-h/j/k/l>), and completion.',
	recommended = function()
		return vim.env.TMUX ~= nil
	end,

	-----------------------------------------------------------------------------
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'tmux' })
			end

			-- Setup filetype settings
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi.ftplugin.tmux', {}),
				pattern = 'tmux',
				callback = function()
					-- Open 'man tmux' in a vertical split with word under cursor.
					local function open_doc()
						local cword = vim.fn.expand('<cword>')
						require('man').open_page(0, { silent = true }, { 'tmux' })
						vim.fn.search(cword)
					end

					vim.opt_local.iskeyword:append('-')

					vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '\n '
						.. 'setlocal iskeyword<'
						.. '| sil! nunmap <buffer> gK'

					vim.keymap.set('n', 'gK', open_doc, { buffer = 0 })
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Seamless navigation between tmux panes and vim splits
	{
		'christoomey/vim-tmux-navigator',
		lazy = false,
		cond = vim.env.TMUX and vim.uv.os_uname().sysname ~= 'Windows_NT',
		-- stylua: ignore
		keys = {
			{ '<C-h>', '<cmd>TmuxNavigateLeft<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Left Window' },
			{ '<C-j>', '<cmd>TmuxNavigateDown<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Lower Window' },
			{ '<C-k>', '<cmd>TmuxNavigateUp<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Upper Window' },
			{ '<C-l>', '<cmd>TmuxNavigateRight<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Right Window' },
		},
		init = function()
			vim.g.tmux_navigator_no_mappings = true
		end,
	},

	-----------------------------------------------------------------------------
	{
		'hrsh7th/nvim-cmp',
		optional = true,
		dependencies = {
			-- nvim-cmp source for tmux
			'andersevenrud/cmp-tmux',
		},
		opts = function(_, opts)
			opts = opts or {}
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = 'tmux',
				priority = 10,
				keyword_length = 3,
				option = { all_panes = true, label = 'tmux' },
			})
		end,
	},
}
