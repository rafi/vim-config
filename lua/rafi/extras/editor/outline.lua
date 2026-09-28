-- Code outline sidebar powered by LSP
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/outline.lua
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/hedyhli/outline.nvim' })
	local icons = require('rafi.util.icons')
	local defaults = require('outline.config').defaults
	local opts = {
		symbols = {
			icons = {},
			filter = vim.deepcopy(icons.kind_filter),
		},
		keymaps = {
			up_and_jump = '<up>',
			down_and_jump = '<down>',
		},
	}
	for kind, symbol in pairs(defaults.symbols.icons) do
		opts.symbols.icons[kind] = {
			icon = icons.kinds[kind] or symbol.icon,
			hl = symbol.hl,
		}
	end
	-- Setup creates the :Outline* commands, replacing the stubs below.
	require('outline').setup(opts)
end

pack.later(load)

-- Stubs until setup runs.
pack.command({ 'Outline', 'OutlineOpen' }, load, { nargs = 0, bang = true })

-- NOTE: Conflict: editor.namu maps <leader>o too.
vim.keymap.set(
	'n',
	'<leader>o',
	'<cmd>Outline<CR>',
	{ desc = 'Toggle outline' }
)
