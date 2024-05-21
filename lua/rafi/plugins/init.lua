-- Plugins initialization
-- https://github.com/rafi/vim-config

if vim.fn.has('nvim-0.9.0') == 0 then
	vim.api.nvim_echo({
		{ 'Upgrade to Neovim >= 0.10.0 for the best experience.\n', 'ErrorMsg' },
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
}
