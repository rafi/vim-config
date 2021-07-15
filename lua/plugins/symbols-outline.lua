-- plugin: symbols-outline.nvim
-- see: https://github.com/simrat39/symbols-outline.nvim
-- rafi settings

vim.g.symbols_outline = {
	highlight_hovered_item = true,
	show_guides = true,
	auto_preview = false,
	position = 'right',
	keymaps = {
		close = '<Esc>',
		goto_location = '<CR>',
		focus_location = 'o',
		hover_symbol = 'p',
		rename_symbol = 'r',
		code_actions = 'a',
	},
	lsp_blacklist = {},
}
