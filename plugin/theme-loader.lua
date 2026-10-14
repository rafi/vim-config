-- Use last-used colorscheme
if require('rafi.config').disabled('theme-loader') then
	return
end

-- Save the colorscheme in rafi.json, unless lua/config/options.lua set
-- another file.
local opts = vim.g.theme_loader or {}
if type(opts) == 'table' then
	opts.json_file_path = opts.json_file_path
		or require('rafi.config').json_path()
	vim.g.theme_loader = opts
end

-- Eager: the plugin restores the colorscheme on VimEnter, before the UI
-- draws, so every colorscheme file, core or extra, adds its colors/ to
-- runtimepath first.
require('rafi.pack').dev(
	'theme-loader.nvim',
	'https://github.com/rafi/theme-loader.nvim'
)
