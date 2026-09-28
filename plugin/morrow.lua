-- Modern dark colorscheme, hybrid improved
if require('rafi.config').disabled('morrow') then
	return
end

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
require('rafi.pack').dev(
	'morrow.nvim',
	'https://github.com/rafi/neo-hybrid.vim'
)
