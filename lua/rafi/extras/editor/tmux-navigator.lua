-- Seamless navigation between tmux panes and vim splits

if not vim.env.TMUX or vim.uv.os_uname().sysname == 'Windows_NT' then
	return
end

-- Eager: tiny, and the maps must work immediately.
vim.g.tmux_navigator_no_mappings = 1
vim.pack.add({ 'https://github.com/christoomey/vim-tmux-navigator' })

local function map()
	-- stylua: ignore start
	vim.keymap.set({ 'n', 't' }, '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { silent = true, desc = 'Go to Left Window' })
	vim.keymap.set({ 'n', 't' }, '<C-j>', '<cmd>TmuxNavigateDown<CR>', { silent = true, desc = 'Go to Lower Window' })
	vim.keymap.set({ 'n', 't' }, '<C-k>', '<cmd>TmuxNavigateUp<CR>', { silent = true, desc = 'Go to Upper Window' })
	vim.keymap.set({ 'n', 't' }, '<C-l>', '<cmd>TmuxNavigateRight<CR>', { silent = true, desc = 'Go to Right Window' })
	-- stylua: ignore end
end

map()
-- rafi.config.keymaps sets its own <C-h/j/k/l> window maps after startup,
-- re-apply after.
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = map,
})
