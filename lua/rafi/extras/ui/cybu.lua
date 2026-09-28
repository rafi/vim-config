-- Cycle buffers with a notification window listing them (cybu.nvim)

local loaded = false
local function load()
	if not loaded then
		loaded = true
		vim.pack.add({
			'https://github.com/nvim-lua/plenary.nvim',
			'https://github.com/ghillb/cybu.nvim',
		})
		require('cybu').setup({})
	end
	return require('cybu')
end

-- NOTE: Conflict: ui.cybu wins over core `[b`/`]b` (bufferline,
-- rafi.config.keymaps) and `<C-Tab>`/`<C-S-Tab>` (tabs) when enabled.
local function set_keys()
	-- stylua: ignore start
	vim.keymap.set('n', '[b', function() load().cycle('prev') end, { desc = 'Prev Buffer' })
	vim.keymap.set('n', ']b', function() load().cycle('next') end, { desc = 'Next Buffer' })
	vim.keymap.set('n', '<C-S-Tab>', function() load().cycle('prev', 'last_used') end, { desc = 'Prev Last-used Buffer' })
	vim.keymap.set('n', '<C-Tab>', function() load().cycle('next', 'last_used') end, { desc = 'Next Last-used Buffer' })
	-- stylua: ignore end
end

set_keys()
-- rafi.config.keymaps loads on `later` and maps the same keys.
vim.api.nvim_create_autocmd('User', {
	group = vim.api.nvim_create_augroup('rafi.cybu', {}),
	pattern = 'RafiKeymaps',
	callback = set_keys,
})
