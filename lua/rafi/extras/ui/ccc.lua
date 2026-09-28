-- Super powerful color picker/colorizer plugin
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/uga-rosa/ccc.nvim' })
	require('ccc').setup({
		highlighter = {
			auto_enable = true,
			lsp = true,
			filetypes = {
				'html',
				'lua',
				'css',
				'scss',
				'sass',
				'less',
				'stylus',
				'javascript',
				'tmux',
				'typescript',
			},
			excludes = { 'lazy', 'mason', 'help', 'neo-tree' },
		},
	})
	-- Its `ccc-highlighter-auto-enable` FileType autocmd only attaches
	-- buffers opened after `setup()`, so re-fire it for buffers already open.
	pack.refire_filetype('ccc-highlighter-auto-enable')
end

pack.on_event('FileType', load)

-- setup() in load() defines the real command.
pack.command('CccPick', load)

vim.keymap.set('n', '<Leader>mc', function()
	load()
	vim.cmd('CccPick')
end, { desc = 'Color-picker' })
