-- LSP: Highlights
-- https://github.com/rafi/vim-config

-- This is part of LunarVim's code, with my modifications.
-- Reference: https://github.com/LunarVim/LunarVim

local M = {}

---@param client lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
	if require('rafi.lib.utils').has('vim-illuminate') then
		-- Skipped setup for document_highlight, illuminate is installed.
		return
	end
	local status_ok, highlight_supported = pcall(function()
		return client.supports_method('textDocument/documentHighlight')
	end)
	if not status_ok or not highlight_supported then
		return
	end

	local group_name = 'lsp_document_highlight'
	local ok, hl_autocmds = pcall(vim.api.nvim_get_autocmds, {
		group = group_name,
		buffer = bufnr,
		event = 'CursorHold',
	})

	if ok and #hl_autocmds > 0 then
		return
	end

	vim.api.nvim_create_augroup(group_name, { clear = false })
	vim.api.nvim_create_autocmd('CursorHold', {
		group = group_name,
		buffer = bufnr,
		callback = vim.lsp.buf.document_highlight,
	})
	vim.api.nvim_create_autocmd('CursorMoved', {
		group = group_name,
		buffer = bufnr,
		callback = vim.lsp.buf.clear_references,
	})
end

return M
