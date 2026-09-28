-- Automatically add closing tags for HTML and JSX
local pack = require('rafi.pack')

pack.on_event('BufReadPre,BufNewFile', function()
	vim.pack.add({ 'https://github.com/windwp/nvim-ts-autotag' })
	require('nvim-ts-autotag').setup({})
	-- Setup only attaches on FileType, attach buffers already open.
	pack.refire_filetype('nvim_ts_xmltag')
end)
