-- Markdown utilities
--

-- Surround visual-selection or word under cursor with markdown link.
local function link_surround()
	local mode = vim.fn.mode()
	local bufnr, off, len, line, idx
	local csrow, cscol, cerow, cecol

	if mode == 'n' then
		local cword = vim.fn.expand('<cword>')
		bufnr, csrow, cscol, off = unpack(vim.fn.getpos('.') or { 0, 0, 0, 0 })
		len = vim.fn.strchars(cword)
		line = vim.fn.getline(csrow)
		idx = vim.fn.stridx(line, cword, 0)
	elseif mode == 'v' or mode == '\22' then
		bufnr, csrow, cscol, off = unpack(vim.fn.getpos('.') or { 0, 0, 0, 0 })
		_, cerow, cecol, _ = unpack(vim.fn.getpos('v') or { 0, 0, 0, 0 })
		if cecol < cscol then
			cscol, cecol = cecol, cscol
		end
		if csrow ~= cerow then
			vim.notify('Cannot link across lines', vim.log.levels.ERROR)
			return
		end
		idx = cscol - 1
		len = cecol - idx
		line = vim.fn.getline(csrow)
		local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
		vim.api.nvim_feedkeys(esc, 'x', true)
	else
		vim.notify('Cannot link across lines', vim.log.levels.ERROR)
		return
	end

	-- Stitch selection with link into original line and replace it.
	local new = vim.fn.strcharpart(line, 0, idx)
		.. '['
		.. vim.fn.strcharpart(line, idx, len)
		.. ']()'
		.. vim.fn.strcharpart(line, idx + len)
	vim.fn.setline(csrow, new)
	vim.fn.setpos('.', { bufnr, csrow, idx + len + 4, off })
	vim.cmd.startinsert()
end

-- Set key-mappings.
local opts = { noremap = true, buffer = 0 }
vim.keymap.set({ 'n', 'x' }, '<C-Return>', link_surround, opts)

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
	.. '\n '
	.. 'sil! nunmap <buffer> <C-Return>'
	.. ' | sil! xunmap <buffer> <C-Return>'
