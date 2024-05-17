-- Plugins: Formatting
-- https://github.com/rafi/vim-config

return {

	-- Import LazyVim's formatting spec in its entirety.
	{ import = 'lazyvim.plugins.formatting' },

	-- Lightweight yet powerful formatter plugin
	{
		'stevearc/conform.nvim',
		-- stylua: ignore
		keys = {
			{ '<leader>cic', '<cmd>ConformInfo<CR>', silent = true, desc = 'Conform Info' },
		},
	},
}
