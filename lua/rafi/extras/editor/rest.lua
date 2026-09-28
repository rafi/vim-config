-- Fast Neovim http client written in Lua
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/rest-nvim/rest.nvim' })
	require('rest-nvim').setup({ request = { skip_ssl_verification = true } })
	-- rest.nvim defines `:Rest` in its ftplugin/http.lua, which missed the
	-- FileType event that triggered this load, so re-fire it.
	pack.refire_filetype('filetypeplugin')
end

pack.on_filetype('http', load)

pack.command('Rest', load, { bang = true })

-- NOTE: Conflict: lang.clangd's buffer-local <leader>ch wins in clangd buffers.
-- stylua: ignore start
vim.keymap.set('n', '<Leader>ch', function() load() vim.cmd.Rest('run') end, { desc = 'Execute HTTP request' })
-- stylua: ignore end
