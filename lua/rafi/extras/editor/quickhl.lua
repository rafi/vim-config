-- Highlight words quickly
local loaded = false
local function load()
	if not loaded then
		loaded = true
		vim.pack.add({ 'https://github.com/t9md/vim-quickhl' })
	end
end

-- The <Plug> maps only exist once the plugin is sourced, so load it first
-- and then feed the <Plug> map (still in visual mode for 'x').
vim.keymap.set({ 'n', 'x' }, '<leader>mt', function()
	load()
	vim.api.nvim_feedkeys(vim.keycode('<Plug>(quickhl-manual-this)'), 'm', false)
end, { desc = 'Highlight word' })
