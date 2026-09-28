-- Underlines other uses of the word under the cursor, in select filetypes
local pack = require('rafi.pack')

-- Read by the plugin's own autoload code at source time: disable globally,
-- the FileType autocmd below opts specific filetypes back in per-buffer.
vim.g.cursorword = 0

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/itchyny/vim-cursorword' })

	local augroup = vim.api.nvim_create_augroup('rafi.cursorword', {})
	vim.api.nvim_create_autocmd('FileType', {
		group = augroup,
		pattern = {
			'conf',
			'dosini',
			'json',
			'markdown',
			'nginx',
			'text',
			'yaml',
		},
		callback = function()
			if vim.wo.diff or vim.wo.previewwindow then
				vim.b.cursorword = 0
			else
				vim.b.cursorword = 1
			end
		end,
	})
	vim.api.nvim_create_autocmd('InsertEnter', {
		group = augroup,
		callback = function()
			if vim.b['cursorword'] == 1 then
				vim.b['cursorword'] = 0
			end
		end,
	})
	vim.api.nvim_create_autocmd('InsertLeave', {
		group = augroup,
		callback = function()
			if vim.b['cursorword'] == 0 then
				vim.b['cursorword'] = 1
			end
		end,
	})
	-- The FileType event that triggered this load already fired before the
	-- group above existed, so re-fire it for that buffer (and any other
	-- already-open buffer of a matching filetype).
	pack.refire_filetype('rafi.cursorword')
end

pack.on_event('FileType', load)
