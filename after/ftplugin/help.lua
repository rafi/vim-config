-- Help utilities
--

if vim.api.nvim_buf_get_option(0, 'buftype') ~= 'help' then
	return
end

---@return integer
local function count_windows()
	local win_count = 0
	local tab_windows = vim.api.nvim_tabpage_list_wins(0)
	for _, winnr in ipairs(tab_windows) do
		local bufnr = vim.api.nvim_win_get_buf(winnr)
		if vim.api.nvim_buf_get_option(bufnr, 'buftype') == '' then
			win_count = win_count + 1
		end
	end
	return win_count
end

vim.wo.spell = false
vim.wo.list = false

if count_windows() > 2 then
	vim.cmd.wincmd('K')
else
	vim.cmd.wincmd('L')
end

-- Key-mappings

local opts = { remap = true, buffer = 0 }
vim.keymap.set('n', '<CR>', '<C-]>', opts)
vim.keymap.set('n', '<BS>', '<C-T>', opts)
vim.keymap.set('n', '<Leader>o', 'gO', opts)

opts = { silent = true, buffer = 0 }
vim.keymap.set('n', 'o', "/'[a-z]\\{2,\\}'<CR>:nohlsearch<CR>", opts)
vim.keymap.set('n', 'O', "?'[a-z]\\{2,\\}'<CR>:nohlsearch<CR>", opts)
vim.keymap.set('n', 'f', '/|\\S\\+|<CR>:nohlsearch<CR>', opts)
vim.keymap.set('n', 'F', 'h?|\\S\\+|<CR>:nohlsearch<CR>', opts)
vim.keymap.set('n', 't', '/\\*\\S\\+\\*<CR>:nohlsearch<CR>', opts)
vim.keymap.set('n', 'T', 'h?\\*\\S\\+\\*<CR>:nohlsearch<CR>', opts)

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
	.. (vim.b.undo_ftplugin ~= nil and ' | ' or '')
	.. 'sil! nunmap <buffer> <CR>'
	.. ' | sil! nunmap <buffer> <BS>'
	.. ' | sil! nunmap <buffer> <Leader>o'
	.. ' | sil! nunmap <buffer> o'
	.. ' | sil! nunmap <buffer> O'
	.. ' | sil! nunmap <buffer> f'
	.. ' | sil! nunmap <buffer> F'
	.. ' | sil! nunmap <buffer> t'
	.. ' | sil! nunmap <buffer> T'
