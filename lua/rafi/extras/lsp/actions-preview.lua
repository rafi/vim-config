-- Fully customizable previewer for LSP code actions
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/aznhe21/actions-preview.nvim' })
	require('actions-preview').setup({})
end

-- Registered as an LSP '*' key so it replaces lspconfig's buffer-local
-- <leader>ca, since extras' '*' keys are applied after the core ones.
require('rafi.util.lang').add({
	keys = {
		['*'] = {
			{
				'<leader>ca',
				function()
					load()
					require('actions-preview').code_actions()
				end,
				desc = 'Code Action',
				mode = { 'n', 'x' },
				has = 'codeAction',
			},
		},
	},
})
