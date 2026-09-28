-- Tree-sitter parser manager, installs parsers on demand (arborist.nvim)
local pack = require('rafi.pack')

-- Both would install parsers and start highlighting. nvim-treesitter wins.
if require('rafi.config').enabled('treesitter.nvim-treesitter') then
	pack.later(function()
		vim.notify(
			'treesitter.arborist: skipped, treesitter.nvim-treesitter is enabled',
			vim.log.levels.WARN
		)
	end)
	return
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		{ src = 'https://github.com/arborist-ts/arborist.nvim', version = 'dev' },
	})
	require('arborist').setup({
		prefer_wasm = false,
		install_popular = false,
		concurrency = vim.uv.available_parallelism(),
		ignore = { 'conf', 'env' },
		-- Lang extras add parsers missing from the registry via
		-- rafi.util.lang.add({ parsers = … }).
		overrides = require('rafi.util.lang').parsers,
	})
	-- Setup only attaches on FileType, enable buffers already open.
	pack.refire_filetype('arborist')
end

pack.on_event('BufReadPre,BufNewFile', load)
pack.later(load)
