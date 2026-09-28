-- Browse synonyms and definitions (telescope extension)

-- editor.telescope loads the extension with its own opts and maps the same
-- key. This file's minimal setup would reset those, so it steps aside.
if require('rafi.config').enabled('editor.telescope') then
	return
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/nvim-lua/plenary.nvim',
		'https://github.com/nvim-telescope/telescope.nvim',
	})
	require('rafi.pack').dev(
		'telescope-thesaurus.nvim',
		'https://github.com/rafi/telescope-thesaurus.nvim'
	)
	local telescope = require('telescope')
	telescope.setup({})
	telescope.load_extension('thesaurus')
end

vim.keymap.set('n', '<localleader>k', function()
	load()
	vim.cmd('Telescope thesaurus lookup')
end, { desc = 'Thesaurus' })
