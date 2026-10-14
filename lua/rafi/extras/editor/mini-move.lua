-- Move lines and selections with Alt-h/j/k/l
local pack = require('rafi.pack')

local function setup()
	vim.pack.add({ 'https://github.com/nvim-mini/mini.move' })
	require('mini.move').setup({})
end

pack.later(setup)

-- NOTE: Conflict: mini.move wins over core `<A-j>`/`<A-k>` when enabled.
-- Re-applied after core keymaps load. Insert-mode maps stay core.
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = setup,
})
