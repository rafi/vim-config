-- Source enabled extras (rafi.json) and user plugin files (lua/plugins/).
-- Runs after core plugin/ files, so extras and user files can override them.
require('rafi.extras').load()

vim.api.nvim_create_user_command('RafiExtras', function()
	require('rafi.extras').show()
end, { desc = 'Toggle Rafi extras' })
