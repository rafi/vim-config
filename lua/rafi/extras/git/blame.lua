-- Show git blame annotations inline, or in a scrollable window
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/FabijanZulj/blame.nvim' })
	-- Setup creates the real :BlameToggle command, replacing the stub below.
	require('blame').setup({
		date_format = '%Y-%m-%d %H:%M',
		merge_consecutive = false,
		max_summary_width = 30,
		mappings = {
			commit_info = 'K',
			stack_push = '>',
			stack_pop = '<',
			show_commit = '<CR>',
			close = { '<Esc>', 'q' },
		},
	})
end

require('rafi.pack').command('BlameToggle', load, { desc = 'Toggle Git blame' })

vim.keymap.set(
	'n',
	'<leader>gb',
	'<cmd>BlameToggle virtual<CR>',
	{ desc = 'Git blame' }
)
vim.keymap.set(
	'n',
	'<leader>gB',
	'<cmd>BlameToggle window<CR>',
	{ desc = 'Git blame (window)' }
)
