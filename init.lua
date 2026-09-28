-- Rafael Bodill's Neovim entry-point
-- https://github.com/rafi/vim-config
--
-- since 2014.

vim.loader.enable()

-- Experimental: ui2 message/cmdline redesign (:h ui2)
-- Avoids "Press ENTER" prompts, highlights cmdline, pager as buffer.
require('vim._core.ui2').enable({
	msg = { targets = 'msg' },
})

require('rafi.config').setup()
