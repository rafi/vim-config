-- Pleasant editing on Git commit messages
if vim.fn.executable('git') == 0 then
	return
end

-- See: https://github.com/rhysd/committia.vim#variables
vim.g.committia_min_window_width = 30
vim.g.committia_edit_window_width = 75
vim.g.committia_hooks = {
	edit_open = function()
		vim.cmd.resize(10)
		local opts = {
			buffer = vim.api.nvim_get_current_buf(),
			silent = true,
		}
		local function map(mode, lhs, rhs)
			vim.keymap.set(mode, lhs, rhs, opts)
		end
		map('n', 'q', '<cmd>quit<CR>')
		map('i', '<C-d>', '<Plug>(committia-scroll-diff-down-half)')
		map('i', '<C-u>', '<Plug>(committia-scroll-diff-up-half)')
		map('i', '<C-f>', '<Plug>(committia-scroll-diff-down-page)')
		map('i', '<C-b>', '<Plug>(committia-scroll-diff-up-page)')
		map('i', '<C-j>', '<Plug>(committia-scroll-diff-down)')
		map('i', '<C-k>', '<Plug>(committia-scroll-diff-up)')
	end,
}

-- Its plugin/ opens on BufReadPost, and only while Vim is starting.
require('rafi.pack').on_event('BufReadPre~COMMIT_EDITMSG', function()
	vim.pack.add({ 'https://github.com/rhysd/committia.vim' })
end)
