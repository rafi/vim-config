-- Minimal statusline, replaces lualine (staline.nvim)

-- Loads at startup so the statusline shows right away.
if not require('rafi.config').disabled('lualine') then
	vim.notify(
		'ui.staline: add \'lualine\' to rafi.json "disabled"',
		vim.log.levels.WARN
	)
end

vim.pack.add({ 'https://github.com/tamton-aquib/staline.nvim' })

require('staline').setup({
	-- stylua: ignore
	sections = {
		left = {
			'▊', ' ', { 'Evil', '󰱯 ' }, ' ',
			'file_size', ' ',
			{ 'StalineFile', 'file_name' }, ' '
		},
		mid = {},
		right = {
			{ 'StalineLSP', 'lsp_name' }, ' ',
			{ 'StalineEnc', function() return vim.bo.fileencoding end }, '  ',
			{ 'StalineCool', 'cool_symbol' }, ' ',
			{ 'StalineGit', 'branch' }, ' ',
		}
	},
	defaults = {
		true_colors = true,
		bg = '#202328',
		branch_symbol = ' ',
	},
	special_table = {
		['neo-tree'] = { 'File Explorer', ' ' },
		TelescopePrompt = { 'Telescope', ' ' },
		Trouble = { 'Trouble', ' ' },
	},
	mode_colors = {
		n = '#2980ad',
		i = '#9ece6a',
	},
})

-- Section colors, re-applied after every colorscheme change.
local function highlights()
	vim.cmd([[hi Evil        guifg=#ae4748 guibg=#1a1c20]])
	vim.cmd([[hi StalineLSP  guifg=#373b41 guibg=#202328]])
	vim.cmd([[hi StalineEnc  guifg=#7d9955 guibg=#1a1c20]])
	vim.cmd([[hi StalineCool guifg=#7d9955 guibg=#1a1c20]])
	vim.cmd([[hi StalineGit  guifg=#8583b3 guibg=#1a1c20]])
	vim.cmd([[hi StalineFile guifg=#8f609e guibg=#1a1c20]])
end
highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('rafi.staline', {}),
	callback = highlights,
})
