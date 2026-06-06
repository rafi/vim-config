-- Rafi's Neovim config loader
-- https://github.com/rafi/vim-config

-- This uses LazyVim's config module.
-- See $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/config/init.lua

local M = {}

---@type table<string, string>
M.deprecated_extras = {
	['rafi.plugins.extras.editor.telescope'] = '`telescope.nvim` is now the default **RafiVim** picker.',
	['rafi.plugins.extras.ui.indent-blankline'] = "Use LazyVim's `indent-blankline.nvim` instead.",
}

-- Overload some LazyVim's config functions.
function M.setup()
	-- Overload deprecated extras.
	local extras = require('lazyvim.util.plugin').deprecated_extras
	for k, v in pairs(M.deprecated_extras) do
		extras[k] = v
	end

	require('vim._core.ui2').enable({})

	-- Add lua/rafi/plugins/extras as list of "extra" sources.
	LazyVim.extras.sources = {
		{
			name = 'LazyVim',
			desc = 'LazyVim extras',
			module = 'lazyvim.plugins.extras',
		},
		{
			name = 'Rafi ',
			desc = 'Rafi extras',
			module = 'rafi.plugins.extras',
		},
		{
			name = 'User ',
			desc = 'User extras',
			module = 'plugins.extras',
		},
	}
end

return M
