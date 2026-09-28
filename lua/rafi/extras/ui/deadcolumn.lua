-- Show colorcolumn dynamically
local pack = require('rafi.pack')

pack.on_event('BufReadPre,BufNewFile', function()
	-- Its plugin/ calls setup() with defaults, so call it again with opts.
	vim.pack.add({ 'https://github.com/Bekaboo/deadcolumn.nvim' })
	require('deadcolumn').setup({ scope = 'visible' })
end)
