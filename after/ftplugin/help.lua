-- Help utilities
--

if vim.bo.buftype ~= 'help' then
	return
end

-- Count the number of file windows in current tabpage.
---@return integer
local function count_windows()
	local win_count = 0
	local tab_windows = vim.api.nvim_tabpage_list_wins(0)
	for _, winnr in ipairs(tab_windows) do
		local bufnr = vim.api.nvim_win_get_buf(winnr)
		if vim.bo[bufnr].buftype == '' then
			win_count = win_count + 1
		end
	end
	return win_count
end

vim.opt_local.spell = false
vim.opt_local.list = false

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
vim.keymap.set('n', '<Tab>', "/'[a-z]\\{2,\\}'<CR>:nohlsearch<CR>", opts)
vim.keymap.set('n', '<S-Tab>', "?'[a-z]\\{2,\\}'<CR>:nohlsearch<CR>", opts)
vim.keymap.set('n', 'o', '/|\\S\\+|<CR>:nohlsearch<CR>', opts)
vim.keymap.set('n', 'O', 'h?|\\S\\+|<CR>:nohlsearch<CR>', opts)
vim.keymap.set('n', 'p', '/\\*\\S\\+\\*<CR>:nohlsearch<CR>', opts)
vim.keymap.set('n', 'P', 'h?\\*\\S\\+\\*<CR>:nohlsearch<CR>', opts)

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '\n '
	.. 'setlocal spell< list<'
	.. ' | sil! nunmap <buffer> <CR>'
	.. ' | sil! nunmap <buffer> <BS>'
	.. ' | sil! nunmap <buffer> <Leader>o'
	.. ' | sil! nunmap <buffer> <Tab>'
	.. ' | sil! nunmap <buffer> <S-Tab>'
	.. ' | sil! nunmap <buffer> o'
	.. ' | sil! nunmap <buffer> O'
	.. ' | sil! nunmap <buffer> p'
	.. ' | sil! nunmap <buffer> P'
