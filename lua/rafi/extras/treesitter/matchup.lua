-- Modern matchit and matchparen
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- Options are read by plugin/, set them first.
	vim.g.matchup_matchparen_offscreen = vim.empty_dict()
	-- Its plugin/ runs `au! matchparen` to disable the builtin, which is now
	-- plugin/matchparen.lua (not .vim) and disabled here, so the group never
	-- exists. Create it so the caught E216 doesn't land in v:errmsg.
	vim.api.nvim_create_augroup('matchparen', { clear = false })
	vim.pack.add({ 'https://github.com/andymass/vim-matchup' })
	-- plugin/ only attaches on FileType, init buffers already open.
	pack.refire_filetype('matchup_filetype')
end

pack.on_event('BufReadPre,BufNewFile', load)
pack.later(load)
