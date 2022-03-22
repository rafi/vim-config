-- plugin: null-ls.nvim
-- see: https://github.com/jose-elias-alvarez/null-ls.nvim
-- rafi settings

-- install:
-- brew install stylua shellcheck vint markdownlint-cli
-- brew install shfmt shellharden hadolint proselint

local builtins = require('null-ls').builtins
local on_attach = require('plugins.lspconfig').on_attach

local function has_exec(filename)
	return function(_)
		return vim.fn.executable(filename) == 1
	end
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
require('null-ls').setup({
	-- Ensure key maps are setup
	on_attach = on_attach,

	-- should_attach = function(bufnr)
	-- 	return not vim.api.nvim_buf_get_name(bufnr):match("^git://")
	-- end,

	sources = {
		-- Whitespace
		builtins.diagnostics.trail_space.with({
			disabled_filetypes = { 'gitcommit' },
		}),

		-- Ansible
		builtins.diagnostics.ansiblelint.with({
			runtime_condition = has_exec('ansible-lint'),
			extra_filetypes = { 'yaml', 'yaml.ansible' },
		}),

		-- Javascript
		builtins.diagnostics.eslint,

		-- Go
		builtins.formatting.gofmt.with({
			runtime_condition = has_exec('gofmt'),
		}),
		builtins.formatting.gofumpt.with({
			runtime_condition = has_exec('gofumpt'),
		}),
		builtins.formatting.golines.with({
			runtime_condition = has_exec('golines'),
		}),

		-- Lua
		builtins.formatting.stylua,

		-- SQL
		builtins.formatting.sqlformat,

		-- Shell
		-- builtins.code_actions.shellcheck,
		builtins.diagnostics.shellcheck.with({
			runtime_condition = has_exec('shellcheck'),
			extra_filetypes = { 'bash' },
		}),
		builtins.formatting.shfmt.with({
			runtime_condition = has_exec('shfmt'),
			extra_filetypes = { 'bash' },
		}),
		builtins.formatting.shellharden.with({
			runtime_condition = has_exec('shellharden'),
			extra_filetypes = { 'bash' },
		}),

		-- Docker
		builtins.diagnostics.hadolint.with({
			runtime_condition = has_exec('hadolint'),
		}),

		-- Vim
		builtins.diagnostics.vint.with({
			runtime_condition = has_exec('vint'),
		}),

		-- Markdown
		builtins.diagnostics.markdownlint.with({
			runtime_condition = has_exec('markdownlint'),
			extra_filetypes = { 'vimwiki' },
		}),
		builtins.diagnostics.proselint.with({
			runtime_condition = has_exec('proselint'),
			extra_filetypes = { 'vimwiki' },
		}),
		-- builtins.code_actions.proselint.with({
		-- 	runtime_condition = has_exec('proselint'),
		-- 	extra_filetypes = { 'vimwiki' },
		-- }),
		-- builtins.diagnostics.write_good.with({
		-- 	runtime_condition = has_exec('write-good'),
		-- 	extra_filetypes = { 'vimwiki' },
		-- }),
		-- builtins.hover.dictionary.with({ extra_filetypes = { 'vimwiki' } }),
		-- builtins.completion.spell.with({ extra_filetypes = { 'vimwiki' } }),
	},
})
