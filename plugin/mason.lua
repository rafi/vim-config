-- Portable package manager for Neovim
if require('rafi.config').disabled('mason') then
	return
end

-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua

local pack = require('rafi.pack')

-- Tools installed by mason, besides LSP servers from mason-lspconfig and
-- tools registered by lua/rafi/extras/lang/<lang>.lua.
local ensure_installed = {
	'stylua',
	'shfmt',
}

pack.later(function()
	require('rafi.util.lsp').mason()
	local mr = require('mason-registry')
	mr:on('package:install:success', function()
		vim.defer_fn(function()
			-- trigger FileType event to possibly load this newly installed LSP server
			local buf = vim.api.nvim_get_current_buf()
			vim.api.nvim_exec_autocmds('FileType', { buffer = buf })
		end, 100)
	end)

	local tools = vim.list_extend(
		vim.deepcopy(ensure_installed),
		require('rafi.util.lang').tools
	)
	mr.refresh(function()
		for _, tool in ipairs(tools) do
			local p = mr.get_package(tool)
			if not p:is_installed() then
				p:install()
			end
		end
	end)
end)

-- Stub until setup runs, e.g. `nvim +Mason`.
pack.command('Mason', function()
	require('rafi.util.lsp').mason()
end, { desc = 'Mason' })

vim.keymap.set('n', '<leader>cm', '<cmd>Mason<CR>', { desc = 'Mason' })
