-- plugin: persisted
-- see: https://github.com/olimorris/persisted.nvim
-- rafi settings

-- disable autoloading if users piped input into nvim
local session_autoload = true
if vim.g.in_pager_mode then
	session_autoload = false
end

local persisted = require('persisted')

persisted.setup({
	autosave = true,
	autoload = session_autoload,
	follow_cwd = false,
	use_git_branch = false,
	ignored_dirs = { '/tmp', '~/.cache' },

	before_save = function()
		require('interface').win.close_plugin_owned()
	end,

	telescope = {
		before_source = function()
	 		persisted.save()
			persisted.stop()
		end,
		after_source = function(session)
			persisted.start()
			print('Started session ' .. session.name)
		end
	}
})
