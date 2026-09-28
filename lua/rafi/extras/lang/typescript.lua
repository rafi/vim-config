-- TypeScript/JavaScript: vtsls language server (after/lsp/vtsls.lua)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/typescript/init.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/typescript/vtsls.lua

local function lsp()
	return require('rafi.util.lsp')
end

require('rafi.util.lang').add({
	servers = {
		vtsls = true,
		ts_ls = false,
		tsc = false,
		tsserver = false,
	},
	-- stylua: ignore
	keys = {
		vtsls = {
			{
				'gD',
				function()
					local win = vim.api.nvim_get_current_win()
					local params = vim.lsp.util.make_position_params(win, 'utf-16')
					lsp().execute({
						command = 'typescript.goToSourceDefinition',
						arguments = { params.textDocument.uri, params.position },
						open = true,
					})
				end,
				desc = 'Goto Source Definition',
			},
			{
				'gR',
				function()
					lsp().execute({
						command = 'typescript.findAllFileReferences',
						arguments = { vim.uri_from_bufnr(0) },
						open = true,
					})
				end,
				desc = 'File References',
			},
			{ '<leader>cM', function() lsp().action['source.addMissingImports.ts']() end, desc = 'Add missing imports' },
			{ '<leader>cD', function() lsp().action['source.fixAll.ts']() end, desc = 'Fix all diagnostics' },
			{
				'<leader>cV',
				function()
					lsp().execute({
						title = 'Select TypeScript Version',
						filter = 'vtsls',
						command = 'typescript.selectTypeScriptVersion',
					})
				end,
				desc = 'Select TS workspace version',
			},
		},
	},
})
