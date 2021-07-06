-- plugin: auto-session
-- see: https://github.com/rmagatti/auto-session
-- rafi settings

local HOME = vim.fn.expand('$HOME')

require('auto-session').setup({
	log_level = 'error',
	auto_session_enable_last_session = false,
	auto_session_root_dir = vim.fn.stdpath('data')..'/sessions/',
	auto_session_enabled = true,
	auto_save_enabled = true,
	auto_restore_enabled = true,
	auto_session_suppress_dirs = {'/etc', '/tmp', HOME, HOME..'/code'}
})
