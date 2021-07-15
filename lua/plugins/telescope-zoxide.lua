-- plugin: telescope-zoxide
-- see: https://github.com/jvgrootveld/telescope-zoxide
-- rafi settings

local z_utils = require('telescope._extensions.zoxide.utils')

require('telescope._extensions.zoxide.config').setup({
	prompt_title = '[ Zoxide directories ]',
	mappings = {
		default = {
			action = function(selection)
				vim.cmd('lcd ' .. selection.path)
			end,
			after_action = function(selection) end
		},
	}
})

require('telescope').load_extension('zoxide')
