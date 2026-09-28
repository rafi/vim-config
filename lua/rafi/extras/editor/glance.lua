-- Pretty window for navigating LSP locations
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- Sources plugin/glance.lua, which creates the :Glance command.
	vim.pack.add({ 'https://github.com/dnlhc/glance.nvim' })
	local glance = require('glance')
	local actions = glance.actions
	glance.setup({
		folds = {
			fold_closed = '󰅂', -- 󰅂 
			fold_open = '󰅀', -- 󰅀 
			folded = true,
		},
		mappings = {
			list = {
				['<C-u>'] = actions.preview_scroll_win(5),
				['<C-d>'] = actions.preview_scroll_win(-5),
				['sg'] = actions.jump_vsplit,
				['sv'] = actions.jump_split,
				['st'] = actions.jump_tab,
				['p'] = actions.enter_win('preview'),
			},
			preview = {
				['q'] = actions.close,
				['p'] = actions.enter_win('list'),
			},
		},
	})
end

pack.later(load)

local function glance(method)
	return function()
		load()
		vim.cmd.Glance(method)
	end
end

-- stylua: ignore start
vim.keymap.set('n', '<leader>cgd', glance('definitions'), { desc = 'Glance Definitions' })
vim.keymap.set('n', '<leader>cgr', glance('references'), { desc = 'Glance References' })
vim.keymap.set('n', '<leader>cgy', glance('type_definitions'), { desc = 'Glance Type Definitions' })
vim.keymap.set('n', '<leader>cgi', glance('implementations'), { desc = 'Glance implementations' })
vim.keymap.set('n', '<leader>cgu', glance('resume'), { desc = 'Glance Resume' })
-- stylua: ignore end

require('rafi.util.mini').on_which_key(function()
	require('which-key').add({ { '<leader>cg', group = 'glance' } })
end)
