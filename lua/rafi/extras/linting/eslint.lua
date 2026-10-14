-- ESLint language server, with fix-all on save (vim.g.eslint_auto_format)
-- Settings live in after/lsp/eslint.lua. Set `vim.g.eslint_auto_format = false`
-- in lua/config/options.lua to disable the fix-all on save.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/linting/eslint.lua
require('rafi.util.lang').add({
	servers = { eslint = true },
})

-- Apply all eslint fixes on save, after the formatters, when autoformat
-- is on.
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('rafi.linting.eslint', {}),
	callback = function(ev)
		if vim.g.eslint_auto_format == false then
			return
		end
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client or client.name ~= 'eslint' then
			return
		end
		local group =
			vim.api.nvim_create_augroup('rafi.linting.eslint.' .. ev.buf, {})
		vim.api.nvim_create_autocmd('BufWritePre', {
			group = group,
			buffer = ev.buf,
			desc = 'ESLint fix all on save',
			callback = function()
				if
					require('rafi.util.format').enabled(ev.buf)
					and vim.fn.exists(':LspEslintFixAll') == 2
				then
					vim.cmd('LspEslintFixAll')
				end
			end,
		})
	end,
})
