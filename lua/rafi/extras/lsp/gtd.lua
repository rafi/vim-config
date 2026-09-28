-- LSP's go-to definition or file, with findup/walk fallbacks (nvim-gtd)
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/hrsh7th/nvim-gtd' })
	require('gtd').setup({
		sources = {
			{ name = 'findup' },
			{
				name = 'walk',
				root_markers = {
					'.git',
					'.neoconf.json',
					'Makefile',
					'package.json',
					'tsconfig.json',
				},
				ignore_patterns = { '/node_modules', '/.git' },
			},
			{ name = 'lsp_definition' },
		},
	})
end

pack.on_event('BufReadPre,BufNewFile', load)

-- NOTE: Conflict: lsp.gtd wins over native `gf` when enabled.
vim.keymap.set('n', 'gf', function()
	load()
	require('gtd').exec({ command = 'split' })
end, { desc = 'Go to definition or file' })
