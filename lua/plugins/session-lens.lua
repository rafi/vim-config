-- plugin: telescope.nvim
-- see: https://github.com/rmagatti/session-lens
-- rafi settings

require('session-lens').setup({
	path_display = { 'shorten' },
	winblend = 0,
})
require('telescope').load_extension('session-lens')
