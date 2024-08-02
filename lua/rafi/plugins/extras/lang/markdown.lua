-- rafi.plugins.extras.lang.markdown
--

LazyVim.on_very_lazy(function()
	vim.filetype.add({
		extension = { mdx = 'markdown.mdx' },
	})
end)

return {
	desc = 'Markdown lang extras, without headlines plugin, and toc generator.',
	recommended = function()
		return LazyVim.extras.wants({
			ft = { 'markdown', 'markdown.mdx' },
			root = 'README.md',
		})
	end,

	{ import = 'lazyvim.plugins.extras.lang.markdown' },

	-----------------------------------------------------------------------------
	-- Generate table of contents for Markdown files
	{
		'mzlogin/vim-markdown-toc',
		cmd = { 'GenTocGFM', 'GenTocRedcarpet', 'GenTocGitLab', 'UpdateToc' },
		ft = 'markdown',
		keys = {
			{ '<leader>mo', '<cmd>UpdateToc<CR>', desc = 'Update table of contents' },
		},
		init = function()
			vim.g.vmt_auto_update_on_save = 0
		end,
	},
}
