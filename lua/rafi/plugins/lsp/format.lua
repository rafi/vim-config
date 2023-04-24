-- LSP: Auto-format on save
-- https://github.com/rafi/vim-config

-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/format.lua

local M = {}

M.autoformat = false

function M.toggle()
	if vim.b.autoformat == false then
		vim.b.autoformat = nil
		M.autoformat = true
	else
		M.autoformat = not M.autoformat
	end
	if M.autoformat then
		vim.notify('Enabled format on save', vim.log.levels.INFO, { title = 'Format' })
	else
		vim.notify('Disabled format on save', vim.log.levels.INFO, { title = 'Format' })
	end
end

---@param opts? {force?:boolean}
function M.format(opts)
	local buf = vim.api.nvim_get_current_buf()
	if vim.b.autoformat == false and not (opts and opts.force) then
		return
	end
	local ft = vim.bo[buf].filetype
	local have_nls = #require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING') > 0

	vim.lsp.buf.format(vim.tbl_deep_extend('force', {
		bufnr = buf,
		filter = function(client)
			if have_nls then
				return client.name == 'null-ls'
			end
			return client.name ~= 'null-ls'
		end,
	}, require('rafi.config').plugin_opts('nvim-lspconfig').format or {}))
end

---@param client lsp.Client
---@param buf integer
function M.on_attach(client, buf)
	if
		client.config
		and client.config.capabilities
		and client.config.capabilities.documentFormattingProvider == false
	then
		return
	end

	if client.supports_method('textDocument/formatting') then
		vim.api.nvim_create_autocmd('BufWritePre', {
			group = vim.api.nvim_create_augroup('LspFormat.' .. buf, {}),
			buffer = buf,
			callback = function()
				if M.autoformat then
					M.format()
				end
			end,
		})
	end
end

return M
