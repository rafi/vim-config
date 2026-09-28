-- File explorer that let's you edit the filesystem like a buffer
-- Command-only: setup hijacks directory buffers (default_file_explorer), so
-- it isn't loaded until :Oil is first used.
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/stevearc/oil.nvim' })
	-- Setup creates the :Oil command, replacing the stub below.
	---@module 'oil'
	---@type oil.SetupOpts
	require('oil').setup({
		keymaps = {
			['<C-h>'] = false,
			['<C-l>'] = false,
			['sg'] = { 'actions.select', opts = { vertical = true } },
			['sv'] = { 'actions.select', opts = { horizontal = true } },
			['st'] = { 'actions.select', opts = { tab = true } },
		},
	})
end

require('rafi.pack').command('Oil', load, {
	desc = 'Open oil file browser on a directory',
	nargs = '*',
	complete = 'dir',
	count = true,
})
