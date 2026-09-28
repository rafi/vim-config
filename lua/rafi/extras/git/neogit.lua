-- Magit clone for Neovim
if vim.fn.executable('git') == 0 then
	return
end

local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/nvim-lua/plenary.nvim',
		-- Integration, set up by its own file.
		'https://github.com/sindrets/diffview.nvim',
		'https://github.com/NeogitOrg/neogit',
	})
	-- See: https://github.com/NeogitOrg/neogit#configuration
	require('neogit').setup({
		disable_signs = false,
		disable_context_highlighting = false,
		disable_commit_confirmation = false,
		graph_style = 'unicode',
		integrations = {
			diffview = true,
		},
	})
end

pack.later(load)

-- Stub until the plugin loads, e.g. `nvim +Neogit`.
pack.command('Neogit', load, { desc = 'Open Neogit' })

---@param popup string
---@param action string
---@param args string[]
local function log(popup, action, args)
	load()
	require('neogit').action(popup, action, args)()
end

vim.keymap.set('n', '<leader>mg', '<cmd>Neogit<CR>', { desc = 'Neogit' })

vim.keymap.set('n', '<leader>gl', function()
	log('log', 'log_all_branches', {
		'--max-count=256',
		'--graph',
		'--decorate',
		'--topo-order',
		'--color',
	})
end, { desc = 'Log all branches' })

vim.keymap.set('x', '<leader>gL', function()
	local file = vim.fn.expand('%')
	vim.cmd([[execute 'normal! \<ESC>']])
	local line_start = vim.fn.getpos("'<")[2]
	local line_end = vim.fn.getpos("'>")[2]
	log(
		'log',
		'log_current',
		{ '-L' .. line_start .. ',' .. line_end .. ':' .. file }
	)
end, { desc = 'Neogit Log for this range' })

vim.keymap.set('n', '<leader>gL', function()
	log('log', 'log_current', { '--', vim.fn.expand('%') })
end, { desc = 'Neogit Log for this file' })
