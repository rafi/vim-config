-- Count plugins with pending vim.pack updates for the statusline

-- Eager: the plugin/ file only defines :Packcount and starts its background
-- check loop on UIEnter (Neovim 0.13+). The count is read by lualine.
require('rafi.pack').dev(
	'packcount.nvim',
	'https://github.com/rafi/packcount.nvim'
)
