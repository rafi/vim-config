-- Python: pyright + ruff (after/lsp/ruff.lua), venv-selector.nvim
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/python.lua
local pack = require('rafi.pack')

vim.filetype.add({
	filename = {
		['dev-requirements.txt'] = 'requirements',
	},
	pattern = {
		['requirements-.*%.txt'] = 'requirements',
	},
})

require('rafi.util.lang').add({
	servers = {
		pyright = true,
		ruff = true,
		basedpyright = false,
		ruff_lsp = false,
	},
})

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/linux-cultist/venv-selector.nvim' })
	require('venv-selector').setup({
		options = {
			notify_user_on_venv_activation = true,
			override_notify = false,
		},
	})
	-- Setup restores cached venvs on FileType, attach buffers already open.
	pack.refire_filetype('VenvSelectorCachedVenv')
	pack.refire_filetype('VenvSelectorUvDetect')
end

-- Load the cached venv automatically in Python files.
pack.on_filetype('python', load)

-- Stub until setup creates the real command.
pack.command('VenvSelect', load, { desc = 'Select VirtualEnv' })

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi.lang.python', {}),
	pattern = 'python',
	callback = function(ev)
		vim.keymap.set(
			'n',
			'<leader>cv',
			'<cmd>:VenvSelect<cr>',
			{ buffer = ev.buf, desc = 'Select VirtualEnv' }
		)
	end,
})
