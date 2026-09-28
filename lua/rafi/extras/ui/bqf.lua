-- Preview and enhanced quickfix window
local pack = require('rafi.pack')

local loaded = false
---@param redetect? boolean Re-fire FileType for open qf buffers
local function load(redetect)
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/kevinhwang91/nvim-bqf' })
	-- Its `after/ftplugin/qf/bqf.vim` calls `bootstrap()`, which only applies
	-- defaults if `setup()` wasn't already called, so set opts first.
	require('bqf').setup({
		auto_resize_height = false,
		func_map = {
			tab = 'st',
			split = 'sv',
			vsplit = 'sg',

			stoggleup = 'K',
			stoggledown = 'J',

			ptoggleitem = 'p',
			ptoggleauto = 'P',
			ptogglemode = 'zp',

			pscrollup = '<C-b>',
			pscrolldown = '<C-f>',

			prevfile = 'gk',
			nextfile = 'gj',

			prevhist = '<S-Tab>',
			nexthist = '<Tab>',
		},
		preview = {
			auto_preview = true,
			should_preview_cb = function(bufnr)
				-- file size greater than 100kb can't be previewed automatically
				local filename = vim.api.nvim_buf_get_name(bufnr)
				local fsize = vim.fn.getfsize(filename)
				if fsize > 100 * 1024 then
					return false
				end
				return true
			end,
		},
	})
	-- nvim-bqf attaches from its qf ftplugin. On the `FileType qf` trigger,
	-- MiniMisc re-fires FileType itself once this returns. `QuickFixCmdPost`
	-- doesn't, so re-set `filetype` on qf buffers that are already open.
	if redetect then
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == 'qf' then
				vim.bo[buf].filetype = 'qf'
			end
		end
	end
end

pack.on_filetype('qf', load)
pack.on_event('QuickFixCmdPost', function()
	load(true)
end)

pack.command('BqfAutoToggle', load)
