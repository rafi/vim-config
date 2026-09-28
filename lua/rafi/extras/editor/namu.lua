-- Flexible symbol navigation (LSP, treesitter, ctags, diagnostics)
-- Setup eagerly requires several modules, so it runs on first use.
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true

	vim.pack.add({ 'https://github.com/bassamsdata/namu.nvim' })
	require('namu').setup({
		namu_symbols = {
			enable = true,
			---@type NamuConfig
			options = {
				movement = {
					next = { '<C-n>', '<C-j>', '<DOWN>' },
					previous = { '<C-p>', '<C-k>', '<UP>' },
				},
			},
		},
	})
end

require('rafi.pack').command('Namu', load, {
	nargs = '+',
	desc = 'Namu plugin command with subcommands',
	complete = true,
})

-- stylua: ignore start
vim.keymap.set('n', '<leader>se', '<cmd>Namu symbols<CR>', { desc = 'Namu symbols' })
vim.keymap.set('n', '<leader>sE', '<cmd>Namu workspace<CR>', { desc = 'Namu workspace symbols' })
-- NOTE: Conflict: editor.outline maps <leader>o too.
vim.keymap.set('n', '<leader>o', '<cmd>Namu sidebar symbols<CR>', { desc = 'Namu sidebar' })
-- stylua: ignore end
