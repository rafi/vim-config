-- Configures LuaLS for editing Neovim config and plugins

---Plugin name to its vim.pack install path, or the name itself when the
---plugin isn't installed.
---@param name string
---@return string
local function lib(name)
	local ok, found = pcall(vim.pack.get, { name }, { info = false })
	return ok and found[1] and found[1].path or name
end

require('rafi.pack').on_filetype('lua', function()
	vim.pack.add({ 'https://github.com/folke/lazydev.nvim' })
	-- Setup creates the :LazyDev command.
	require('lazydev').setup({
		library = {
			{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
			{ path = lib('snacks.nvim'), words = { 'Snacks' } },
			{ path = lib('nvim-lspconfig'), words = { 'lspconfig.settings' } },
		},
	})
end)
