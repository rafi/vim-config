-- plugin: persisted
-- see: https://github.com/olimorris/persisted.nvim
-- rafi settings

-- disable autoloading if users piped input into nvim
local autoload = true
if vim.g.in_pager_mode then
	autoload = false
end

local persisted = require('persisted')

persisted.setup({
	autosave = true,
	autoload = autoload,
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
			-- vim.api.nvim_input("<ESC>:%bd<CR>")
		end,
		after_source = function(session)
			persisted.start()
			print("Started session "..session)
		end
	}
})
