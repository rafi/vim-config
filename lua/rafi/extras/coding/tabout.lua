-- Tab out of brackets and quotes
local pack = require('rafi.pack')

pack.on_event('InsertEnter', function()
	vim.pack.add({ 'https://github.com/abecodes/tabout.nvim' })
	-- Setup creates the insert-mode maps.
	require('tabout').setup({
		tabkey = '<C-l>',
		backwards_tabkey = '<S-C-L>',
	})
end)
