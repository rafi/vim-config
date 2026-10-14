-- Edit and review GitHub issues and pull requests (octo.nvim)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/util/octo.lua
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/nvim-lua/plenary.nvim',
		'https://github.com/pwntester/octo.nvim',
	})
	require('octo').setup({
		enable_builtin = true,
		default_to_projects_v2 = true,
		default_merge_method = 'squash',
		picker = 'snacks',
	})
end

-- Octo buffers are markdown for treesitter.
vim.treesitter.language.register('markdown', 'octo')

-- Clear buftype before exit, so sessions keep octo windows.
vim.api.nvim_create_autocmd('ExitPre', {
	group = vim.api.nvim_create_augroup('octo_exit_pre', { clear = true }),
	callback = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].filetype == 'octo' then
				vim.bo[buf].buftype = ''
			end
		end
	end,
})

-- `:Octo` comes from setup(), so the stub loads first, then re-runs it.
pack.command('Octo', load, { nargs = '*', range = true, complete = true })

-- Opening an octo:// buffer loads the plugin, then reads the buffer once.
vim.api.nvim_create_autocmd('BufReadCmd', {
	group = vim.api.nvim_create_augroup('rafi.octo', {}),
	pattern = 'octo://*',
	once = true,
	callback = function(ev)
		load()
		require('octo').load_buffer({ bufnr = ev.buf })
	end,
})

-- Buffer-local group labels and completion triggers inside octo buffers.
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi.octo.ft', {}),
	pattern = 'octo',
	callback = function(ev)
		local buf = ev.buf
		vim.keymap.set('i', '@', '@<C-x><C-o>', { buffer = buf, silent = true })
		vim.keymap.set('i', '#', '#<C-x><C-o>', { buffer = buf, silent = true })
		require('rafi.util.mini').on_which_key(function()
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end
			require('which-key').add({
				{ '<localleader>a', group = 'assignee (Octo)', buffer = buf },
				{ '<localleader>c', group = 'comment/code (Octo)', buffer = buf },
				{ '<localleader>l', group = 'label (Octo)', buffer = buf },
				{ '<localleader>i', group = 'issue (Octo)', buffer = buf },
				{ '<localleader>r', group = 'react (Octo)', buffer = buf },
				{ '<localleader>p', group = 'pr (Octo)', buffer = buf },
				{ '<localleader>pr', group = 'rebase (Octo)', buffer = buf },
				{ '<localleader>ps', group = 'squash (Octo)', buffer = buf },
				{ '<localleader>v', group = 'review (Octo)', buffer = buf },
				{ '<localleader>g', group = 'goto_issue (Octo)', buffer = buf },
			})
		end)
	end,
})

local function map(lhs, cmd, desc)
	vim.keymap.set('n', lhs, '<cmd>' .. cmd .. '<CR>', { desc = desc })
end

-- These replace snacks' GitHub pickers.
-- NOTE: Conflict: octo wins over snacks (<leader>gi/gI/gp/gP) when enabled
map('<leader>gi', 'Octo issue list', 'List Issues (Octo)')
map('<leader>gI', 'Octo issue search', 'Search Issues (Octo)')
map('<leader>gp', 'Octo pr list', 'List PRs (Octo)')
map('<leader>gP', 'Octo pr search', 'Search PRs (Octo)')
map('<leader>gr', 'Octo repo list', 'List Repos (Octo)')
-- NOTE: Conflict: octo wins over snacks <leader>gS (Git Stash) when enabled.
-- editor.telescope also maps it.
map('<leader>gS', 'Octo search', 'Search (Octo)')
