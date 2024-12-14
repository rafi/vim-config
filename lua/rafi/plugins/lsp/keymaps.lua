-- LSP: Key-maps
-- https://github.com/rafi/vim-config

local M = {}

---@type LazyKeysLspSpec[]|nil
M._keys = nil

---@return LazyKeysLspSpec[]
function M.get()
	if M._keys then
		return M._keys
	end

	---@class PluginLspKeys
	-- stylua: ignore
	M._keys =  {
		{ 'gd', vim.lsp.buf.definition, desc = 'Goto Definition', has = 'definition' },
		{ 'gr', vim.lsp.buf.references, desc = 'References', nowait = true },
		{ 'gI', vim.lsp.buf.implementation, desc = 'Goto Implementation' },
		{ 'gy', vim.lsp.buf.type_definition, desc = 'Goto Type Definition' },
		{ 'gD', vim.lsp.buf.declaration, desc = 'Goto Declaration' },
		{ 'K', function() return vim.lsp.buf.hover() end, desc = 'Hover' },
		{ 'gK', function() return vim.lsp.buf.signature_help() end, desc = 'Signature Help', has = 'signatureHelp' },

		{ '<Leader>ca', vim.lsp.buf.code_action, mode = { 'n', 'x' }, has = 'codeAction', desc = 'Code Action' },
		{ '<leader>cc', vim.lsp.codelens.run, desc = 'Run Codelens', mode = { 'n', 'x' }, has = 'codeLens' },
		{ '<leader>cC', vim.lsp.codelens.refresh, desc = 'Refresh & Display Codelens', mode = { 'n' }, has = 'codeLens' },
		{ '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File', mode = {'n'}, has = { 'workspace/didRenameFiles', 'workspace/willRenameFiles' }},
		{ '<leader>cr', vim.lsp.buf.rename, desc = 'Rename', has = 'rename' },
		{ '<leader>cA', LazyVim.lsp.action.source, desc = 'Source Action', has = 'codeAction' },

		{ ']]', function() Snacks.words.jump(vim.v.count1) end, has = 'documentHighlight',
			desc = 'Next Reference', cond = function() return Snacks.words.is_enabled() end },
		{ '[[', function() Snacks.words.jump(-vim.v.count1) end, has = 'documentHighlight',
			desc = 'Prev Reference', cond = function() return Snacks.words.is_enabled() end },
		{ '<a-n>', function() Snacks.words.jump(vim.v.count1, true) end, has = 'documentHighlight',
			desc = 'Next Reference', cond = function() return Snacks.words.is_enabled() end },
		{ '<a-p>', function() Snacks.words.jump(-vim.v.count1, true) end, has = 'documentHighlight',
			desc = 'Prev Reference', cond = function() return Snacks.words.is_enabled() end },

		{ '<Leader>csi', vim.lsp.buf.incoming_calls, desc = 'Incoming calls' },
		{ '<Leader>cso', vim.lsp.buf.outgoing_calls, desc = 'Outgoing calls' },
		{ '<Leader>fwa', vim.lsp.buf.add_workspace_folder, desc = 'Show Workspace Folders' },
		{ '<Leader>fwr', vim.lsp.buf.remove_workspace_folder, desc = 'Remove Workspace Folder' },
		{ '<Leader>fwl', '<cmd>lua =vim.lsp.buf.list_workspace_folders()<CR>', desc = 'List Workspace Folders' },
	}

	return M._keys
end

---@param method string|string[]
function M.has(buffer, method)
	if type(method) == 'table' then
		for _, m in ipairs(method) do
			if M.has(buffer, m) then
				return true
			end
		end
		return false
	end
	method = method:find('/') and method or 'textDocument/' .. method
	local clients = LazyVim.lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

---@return LazyKeysLsp[]
function M.resolve(buffer)
	local Keys = require('lazy.core.handler.keys')
	if not Keys.resolve then
		return {}
	end
	local spec = vim.tbl_extend('force', {}, M.get())
	local opts = LazyVim.opts('nvim-lspconfig')
	local clients = LazyVim.lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		local maps = opts.servers[client.name] and opts.servers[client.name].keys
			or {}
		vim.list_extend(spec, maps)
	end
	return Keys.resolve(spec)
end

---@param buffer integer
function M.on_attach(_, buffer)
	local Keys = require('lazy.core.handler.keys')
	local keymaps = M.resolve(buffer)

	for _, keys in pairs(keymaps) do
		local has = not keys.has or M.has(buffer, keys.has)
		local cond = not (
			keys.cond == false
			or ((type(keys.cond) == 'function') and not keys.cond())
		)

		if has and cond then
			local opts = Keys.opts(keys) --[[@as vim.keymap.set.Opts]]
			---@diagnostic disable-next-line: inject-field
			opts.cond = nil
			---@diagnostic disable-next-line: inject-field
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer
			vim.keymap.set(keys.mode or 'n', keys.lhs, keys.rhs, opts)
		end
	end
end

return M
