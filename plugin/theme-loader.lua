-- Use last-used colorscheme
if require('rafi.config').disabled('theme-loader') then
	return
end

-- Eager: autostart restores the colorscheme on VimEnter, so every
-- colorscheme file, core or extra, adds its colors/ to runtimepath first.
require('rafi.pack').dev(
	'theme-loader.nvim',
	'https://github.com/rafi/theme-loader.nvim'
)
require('theme-loader').setup()
