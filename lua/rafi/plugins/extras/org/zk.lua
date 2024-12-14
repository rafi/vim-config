-- rafi.plugins.extras.org.zk
--

return {

	-- Extension for the zk plain text note-taking assistant
	{
		'zk-org/zk-nvim',
		main = 'zk',
		ft = 'markdown',
		cmd = { 'ZkNew', 'ZkNotes', 'ZkTags', 'ZkMatch' },
		-- stylua: ignore
		keys = {
			{ '<leader>zn', "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = 'Zk New' },
			{ '<leader>zo', "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", desc = 'Zk Notes' },
			{ '<leader>zt', '<Cmd>ZkTags<CR>', desc = 'Zk Tags' },
			{ '<leader>zf', "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", desc = 'Zk Search' },
			{ '<leader>zg', ":'<,'>ZkMatch<CR>", mode = 'x', desc = 'Zk Match' },
			{ '<leader>zb', '<Cmd>ZkBacklinks<CR>', desc = 'Zk Backlinks' },
			{ '<leader>zl', '<Cmd>ZkLinks<CR>', desc = 'Zk Links' },
		},
		opts = {
			picker = 'telescope',
			-- lsp = {
			-- 	auto_attach = {
			-- 		enabled = false,
			-- 	},
			-- },
		},
	},

	{
		'nvim-telescope/telescope.nvim',
		optional = true,
		keys = {
			{ '<localleader>w', '<cmd>ZkNotes<CR>', desc = 'Zk notes' },
		},
	},
}
