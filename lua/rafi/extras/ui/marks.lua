-- Interacting with and manipulating marks
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/chentoast/marks.nvim' })
	require('marks').setup({
		sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
		bookmark_1 = { sign = '󰈼' }, -- ⚐ ⚑ 󰈻 󰈼 󰈽 󰈾 󰈿 󰉀
		mappings = {
			annotate = 'm<Space>',
		},
	})
	-- Its own `Marks_autocmds` (BufEnter/BufDelete) and refresh timer attach
	-- to the current buffer as soon as it's active. So no FileType re-fire
	-- is needed for buffers already open.
end

pack.on_event('FileType', load)

-- NOTE: Conflict: ui.bookmarks (a default extra) also maps m], m[, m<Space>
-- and m/. marks.nvim maps the first three in setup() on the first FileType,
-- after bookmarks' maps, so this extra always wins them. Both extras map
-- m/ below.
vim.keymap.set('n', 'm/', function()
	load()
	vim.cmd('MarksListAll')
end, { desc = 'Marks from all opened buffers' })
