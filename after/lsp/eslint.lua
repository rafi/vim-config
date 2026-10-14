-- ESLint language server
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/linting/eslint.lua
---@type vim.lsp.Config
return {
	settings = {
		-- Helps eslint find the eslintrc when it's in a subfolder instead of
		-- the cwd root.
		workingDirectories = { mode = 'auto' },
		-- Fix-all on save is done by lua/rafi/extras/linting/eslint.lua
		format = vim.g.eslint_auto_format == nil or vim.g.eslint_auto_format,
	},
}
