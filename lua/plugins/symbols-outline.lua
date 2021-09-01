-- plugin: symbols-outline.nvim
-- see: https://github.com/simrat39/symbols-outline.nvim
-- rafi settings

vim.g.symbols_outline = {
	highlight_hovered_item = true,
	show_guides = true,
	auto_preview = false,
	position = 'right',
	keymaps = {
		close = { '<Esc>', 'q' },
		goto_location = '<CR>',
		focus_location = 'o',
		toggle_preview = 'p',
		hover_symbol = 'K',
		rename_symbol = 'r',
		code_actions = 'a',
	},
	lsp_blacklist = {},
}

vim.cmd([[
	augroup user-symbols-outline
		autocmd!
		autocmd FileType Outline setlocal cursorline winhighlight=CursorLine:UserSelectionBackground
		autocmd WinEnter,BufEnter Outline setlocal cursorline
		autocmd WinLeave,BufLeave Outline setlocal nocursorline
	augroup END
]])
