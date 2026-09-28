-- Improved diagnostics and location/quickfix list windows
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/stevearc/quicker.nvim' })
	---@module "quicker"
	---@type quicker.SetupOptions
	require('quicker').setup({
		edit = {
			enabled = false,
			autosave = false,
		},
		highlight = {
			lsp = false,
			load_buffers = false,
		},
		-- stylua: ignore
		keys = {
			{ '>', function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end, desc = 'Expand quickfix context' },
			{ '<', function() require('quicker').collapse() end, desc = 'Collapse quickfix context' },
		},
	})
	-- Its `quicker` FileType-qf autocmd only attaches buffers opened after
	-- `setup()`, so re-fire it for buffers already open.
	pack.refire_filetype('quicker')
end

pack.on_filetype('qf', load)
pack.on_event('QuickFixCmdPost', load)
