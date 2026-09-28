-- Full config startup in a child Neovim, with the extras listed in the
-- rafi.json tests/minit.lua writes into the sandbox.

local H = require('helpers')

-- The editor.tmux-navigator extra only loads inside tmux. The child
-- inherits this, so its maps are tested outside tmux too.
vim.env.TMUX = vim.env.TMUX or 'rafi-test'

local child = MiniTest.new_child_neovim()

local T = MiniTest.new_set({
	hooks = {
		pre_case = function()
			H.start_config(child)
		end,
		post_case = child.stop,
	},
})

T['starts without errors or messages'] = function()
	H.eq(child.v.errmsg, '')
	H.eq(child.cmd_capture('messages'), '')
end

T['sets leaders'] = function()
	H.eq(child.g.mapleader, ' ')
	H.eq(child.g.maplocalleader, ';')
end

T['loads keymaps on later'] = function()
	H.eq(child.fn.maparg('<leader>w', 'n'), '<Cmd>write<CR>')
end

T['restores clipboard on later'] = function()
	H.expect.no_equality(child.o.clipboard, '')
end

T['defines :RafiExtras'] = function()
	H.eq(child.fn.exists(':RafiExtras'), 2)
end

-- Modules loaded eagerly or on `later`, not on a file or event.
T['loads core plugins'] = function()
	local mods = { 'snacks', 'which-key', 'lualine', 'bufferline' }
	H.eq(H.not_loaded(child, mods), {})
end

T['lazy-loads on events'] = function()
	local lazy = { 'blink.cmp', 'gitsigns' }
	H.eq(H.not_loaded(child, lazy), lazy)
	child.cmd('edit ' .. H.root .. '/init.lua')
	child.type_keys('i')
	H.eq(H.not_loaded(child, lazy), {})
	H.eq(child.v.errmsg, '')
end

-- vim.pack.add() in config plugin/ and extras files runs after init, so it
-- sources the plugin's own plugin/ files itself. They must run exactly once.
T['sources plugin/ files once'] = function()
	local scripts = child.cmd_capture('scriptnames')
	for _, pattern in ipairs({
		'vim%-tmux%-navigator/plugin/',
		'leap%.nvim/plugin/',
		'vim%-matchup/plugin/matchup%.vim',
	}) do
		local _, count = scripts:gsub(pattern, '')
		H.eq({ pattern, count }, { pattern, 1 })
	end
	H.eq(child.fn.exists(':TmuxNavigateLeft'), 2)
	H.expect.no_equality(
		child.fn.maparg('<C-h>', 'n'):find('TmuxNavigateLeft'),
		nil
	)
	H.expect.no_equality(child.fn.maparg('<Plug>(leap)', 'n'), '')
	H.eq(child.g.loaded_matchup, 1)
end

T['registers rafi autocmd groups'] = function()
	local missing = child.lua(
		[[
		return vim.tbl_filter(function(group)
			return #vim.api.nvim_get_autocmds({ group = 'rafi.' .. group }) == 0
		end, ...)
	]],
		{
			{
				'checktime',
				'highlight_yank',
				'resize_splits',
				'close_with_q',
				'man_unlisted',
				'wrap_spell',
				'json_conceal',
				'auto_create_dir',
				'last_loc',
			},
		}
	)
	H.eq(missing, {})
end

-- rafi.config.keymaps overrides some of LazyVim's defaults it ported.
T['applies keymap overrides'] = function()
	H.eq(child.fn.maparg('<S-h>', 'n'), '')
	H.eq(child.fn.maparg('<leader>wd', 'n'), '')
	H.eq(child.fn.maparg('<A-j>', 'n'), '<Cmd>tabnext<CR>')
end

T['sets a colorscheme'] = function()
	H.expect.no_equality(child.g.colors_name, vim.NIL)
end

return T
