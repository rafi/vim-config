-- plugin: gitsigns.nvim
-- see: https://github.com/lewis6991/gitsigns.nvim
-- rafi settings

require('gitsigns').setup({
	signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
	numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		interval = 1000,
		follow_files = true
	},
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	preview_config = {
		border = 'rounded',
	},
	keymaps = {
		noremap = true,

		['n ]g'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
		['n [g'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

		['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
		['x <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
		['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
		['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
		['x <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
		['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
		['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
		['n gs']         = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
		['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
		['n <leader>hl'] = '<cmd>lua require("user").githunk.publish_loclist(true)<CR>',

		-- Text objects
		['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
		['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
	},
})
