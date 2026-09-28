-- Automatically save and restore sessions

if vim.g.started_by_firenvim or vim.g.vscode then
	return
end

-- Eager: session restore happens on VimEnter.
vim.pack.add({ 'https://github.com/rmagatti/auto-session' })

---@module "auto-session"
---@type AutoSession.Config
require('auto-session').setup({
	-- allowed_dirs = { '~/**' },
	suppressed_dirs = { vim.env.TMPDIR or '/tmp', '/private/tmp' },
	root_dir = vim.fn.stdpath('state') .. '/sessions/',
	session_lens = {
		session_control = {
			control_dir = vim.fn.stdpath('state') .. '/auto_session/',
		},
	},
})

-- stylua: ignore start
vim.keymap.set('n', '<localleader>s', '<cmd>AutoSession search<CR>', { desc = 'Session search' })
-- stylua: ignore end
