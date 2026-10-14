-- C/C++: clangd (after/lsp/clangd.lua) and clangd_extensions.nvim
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/clangd.lua
local pack = require('rafi.pack')

require('rafi.util.lang').add({
	servers = { clangd = true },
	keys = {
		clangd = {
			-- NOTE: Conflict: editor.rest maps <leader>ch globally. This
			-- buffer-local map wins in buffers with clangd attached.
			{
				'<leader>ch',
				'<cmd>LspClangdSwitchSourceHeader<cr>',
				desc = 'Switch Source/Header (C/C++)',
			},
		},
	},
})

local loaded = false

-- Load clangd_extensions.nvim and set up its AST icons.
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/dchinmay2/clangd_extensions.nvim' })
	require('clangd_extensions').setup({
		-- Floats default to no border, so follow 'winborder' like the rest.
		memory_usage = { border = vim.o.winborder },
		symbol_info = { border = vim.o.winborder },
		ast = {
			-- These require codicons (https://github.com/microsoft/vscode-codicons)
			role_icons = {
				type = '',
				declaration = '',
				expression = '',
				specifier = '',
				statement = '',
				['template argument'] = '',
			},
			kind_icons = {
				Compound = '',
				Recovery = '',
				TranslationUnit = '',
				PackExpansion = '',
				TemplateTypeParm = '',
				TemplateTemplateParm = '',
				TemplateParamObject = '',
			},
		},
	})
end

-- Load on C/C++ files. Its commands don't need an LSP client.
pack.on_filetype('c,cpp,objc,objcpp', load)
