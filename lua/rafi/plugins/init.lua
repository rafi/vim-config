-- Plugins initialization
-- https://github.com/rafi/vim-config

if vim.fn.has('nvim-0.9.0') == 0 then
	vim.api.nvim_echo({
		{ 'Upgrade to Neovim >= 0.9.0 for the best experience.\n', 'ErrorMsg' },
		{ 'Press any key to exit', 'MoreMsg' },
	}, true, {})
	vim.fn.getchar()
	vim.cmd([[quit]])
	return {}
end

require('rafi.config').init()

return {

	-- Modern plugin manager for Neovim
	{ 'folke/lazy.nvim', version = '*' },

	-- Lua functions library
	{ 'nvim-lua/plenary.nvim', lazy = false },

	{
		'folke/snacks.nvim',
		priority = 1000,
		lazy = false,
		opts = {},
		config = function(_, opts)
			local notify = vim.notify
			require('snacks').setup(opts)
			-- HACK: restore vim.notify after snacks setup and let noice.nvim take over
			-- this is needed to have early notifications show up in noice history
			if LazyVim.has('noice.nvim') then
				vim.notify = notify
			end
		end,
	},
}
