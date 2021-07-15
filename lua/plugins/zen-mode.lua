-- plugin: zen-mode.nvim
-- See: https://github.com/folke/zen-mode.nvim
-- rafi settings

require('zen-mode').setup {
	window = {
		backdrop = 0.98,
		width = 82,
		height = 1,
		options = {
			-- signcolumn = 'no', -- disable signcolumn
			-- number = false, -- disable number column
			-- relativenumber = false, -- disable relative numbers
			-- cursorline = false, -- disable cursorline
			-- cursorcolumn = false, -- disable cursor column
			-- foldcolumn = '0', -- disable fold column
			-- list = false, -- disable whitespace characters
		},
	},
	plugins = {
		tmux = { enabled = true }
	}
}
