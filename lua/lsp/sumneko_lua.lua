-- sumneko-lua-language-server settings
--

-- local plugins_path = vim.fn.stdpath('data') .. '/dein/repos/github.com'

local settings = {
	Lua = {
		runtime = {
			version = 'LuaJIT',
			path = vim.fn.split(package.path, ';'),
		},
		diagnostics = {
			enable = true,
			globals = {
				'vim',
				'use',
				'describe',
				'it',
				'assert',
				'before_each',
				'after_each',
			},
		},
		telemetry = {
			enable = false,
		},
		-- workspace = {
		-- 	-- Make the server aware of Neovim runtime files
		-- 	-- library = vim.api.nvim_get_runtime_file('', true),
		-- 	library = {
		-- 		[vim.fn.stdpath('config') .. '/lua'] = true,
		-- 		[vim.fn.expand('$VIMRUNTIME/lua')] = true,
		-- 		[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
		-- 		[plugins_path .. '/nvim-lua/plenary.nvim/lua'] = true,
		-- 		[plugins_path] = true,
		-- 	},
		-- },
	},
}

local function config(_)
	return settings
end

return {
	config = config,
}
