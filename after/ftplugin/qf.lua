-- qf/loclist key-bindings
--

local function get_entry()
	local line = vim.api.nvim_get_current_line()
	local parts = vim.split(
		line,
		'[│┃┆┇╎╏║|█▉▊▋▌▍▎▏▐░▒▓▕]'
	)
	if #parts > 2 then
		local pos = vim.split(parts[2], ' col ')
		if #pos > 1 then
			parts[2] = pos[1]
			parts[3] = pos[2]
		end
	end
	vim.notify(vim.inspect(parts))
	parts[1] = vim.trim(parts[1])
	if parts ~= nil and #parts > 0 then
		return parts[1],
			tonumber(vim.trim(parts[2]) or 0),
			tonumber(vim.trim(parts[3]) or 0)
	end
end

local function preview_popup()
	local path, lnum, col = get_entry()
	if path ~= nil then
		require('rafi.util.preview').open({ file = path, lnum = lnum, lcol = col })
	end
end

local function preview_split()
	vim.cmd([[ silent! noautocmd wincmd P ]])
	if vim.wo.previewwindow then
		vim.cmd([[ bdelete! | noautocmd wincmd p ]])
	end
	local entry, lnum, _ = get_entry()
	if entry == nil then
		return
	end

	local args = ''
	if lnum ~= nil then
		args = '+' .. lnum .. ' '
	end
	vim.cmd('vertical pedit! ' .. args .. entry)
	vim.cmd('noautocmd vertical resize ' .. (vim.go.columns / 2))
end

local closer = vim.fn.win_gettype(0) == 'loclist' and 'lclose' or 'cclose'
local opts = { buffer = vim.api.nvim_get_current_buf(), silent = true }

vim.keymap.set('n', '<CR>', '<CR>:' .. closer .. '<CR>', opts)
vim.keymap.set('n', '<S-Return>', '<CR>', opts)
vim.keymap.set('n', 'o', '<CR>:noautocmd wincmd p<CR>', opts)
vim.keymap.set('n', 'sg', '<C-w><CR><C-w>L<C-w>=', opts)
vim.keymap.set('n', 'sv', '<C-w><CR><C-w>=', opts)
vim.keymap.set('n', 'st', '<C-w><CR><C-w>T', opts)
vim.keymap.set('n', 'p', preview_popup, opts)
vim.keymap.set('n', 'P', preview_split, opts)

-- Use `nunmap` (the mappings above are normal-mode) and separate with
-- newlines, not ` | `: `:unmap` keeps the space before `|` in its {lhs}
-- (`:h map-trailing-white`), so it fails with E31 (hidden by `silent!`, but
-- still sets `v:errmsg`), e.g. on a second `:copen` for the same buffer.
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
	.. '\n'
	.. table.concat({
		'sil! nunmap <buffer> <CR>',
		'sil! nunmap <buffer> <S-Return>',
		'sil! nunmap <buffer> o',
		'sil! nunmap <buffer> sg',
		'sil! nunmap <buffer> sv',
		'sil! nunmap <buffer> st',
		'sil! nunmap <buffer> p',
		'sil! nunmap <buffer> P',
	}, '\n')
