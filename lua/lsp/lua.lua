-- sumneko-lua-language-server settings
--

local settings = {
	Lua = {
		runtime = { version = 'LuaJIT', path = vim.split(package.path, ';'), },
		diagnostics = {
			enable = true,
			globals = {'vim', 'use', 'describe', 'it', 'assert', 'before_each', 'after_each'},
		},
		workspace = {
			preloadFileSize = 1000,
			maxPreload = 2000,
			library = {
				[vim.fn.expand('$VIMRUNTIME/lua')] = true,
				[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
				[vim.fn.stdpath('config') .. '/lua'] = true,
				-- [vim.fn.stdpath('data') .. '/site/pack'] = true,
			},
		},
	}
}

local function config(server_config)
	server_config.settings = settings

	-- See https://github.com/folke/lua-dev.nvim
	return require('lua-dev').setup({
		lspconfig = server_config,
		library = {
			vimruntime = true, -- runtime path
			types = true, -- full signature, docs and completion
			plugins = { 'plenary.nvim' },
		},
	})
end

return {
	config = config,
}
