-- LSP: Key-maps
-- https://github.com/rafi/vim-config

local M = {}

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
	if M._keys then
		return M._keys
	end
	local format = function()
		require('rafi.plugins.lsp.format').format({ force = true })
	end

	---@class PluginLspKeys
	-- stylua: ignore
	M._keys =  {
		{ 'gD', vim.lsp.buf.declaration, desc = 'Goto Declaration', has = 'declaration' },
		{ 'gd', vim.lsp.buf.definition, desc = 'Goto Definition', has = 'definition' },
		{ 'gr', vim.lsp.buf.references, desc = 'References', has = 'references' },
		{ 'gy', vim.lsp.buf.type_definition, desc = 'Goto Type Definition', has = 'typeDefinition' },
		{ 'gi', vim.lsp.buf.implementation, desc = 'Goto Implementation', has = 'implementation' },
		{ 'gK', vim.lsp.buf.signature_help, desc = 'Signature Help', has = 'signatureHelp' },
		{ '<C-g>h', vim.lsp.buf.signature_help, mode = 'i', desc = 'Signature Help', has = 'signatureHelp' },
		{ ']d', M.diagnostic_goto(true), desc = 'Next Diagnostic' },
		{ '[d', M.diagnostic_goto(false), desc = 'Prev Diagnostic' },
		{ ']e', M.diagnostic_goto(true, 'ERROR'), desc = 'Next Error' },
		{ '[e', M.diagnostic_goto(false, 'ERROR'), desc = 'Prev Error' },

		{ ',wa', vim.lsp.buf.add_workspace_folder, desc = 'Show Workspace Folders' },
		{ ',wr', vim.lsp.buf.remove_workspace_folder, desc = 'Remove Workspace Folder' },
		{ ',wl', '<cmd>lua =vim.lsp.buf.list_workspace_folders()<CR>', desc = 'List Workspace Folders' },

		{ 'K', function()
			-- Show hover documentation or folded lines.
			local winid = require('rafi.lib.utils').has('nvim-ufo')
				and require('ufo').peekFoldedLinesUnderCursor() or nil
			if not winid then
				vim.lsp.buf.hover()
			end
		end },

		{ '<Leader>ud', function() M.diagnostic_toggle(false) end, desc = 'Disable Diagnostics' },
		{ '<Leader>uD', function() M.diagnostic_toggle(true) end, desc = 'Disable All Diagnostics' },

		{ '<leader>cl', '<cmd>LspInfo<cr>' },
		{ '<leader>cf', format, desc = 'Format Document', has = 'formatting' },
		{ '<leader>cf', format, mode = 'x', desc = 'Format Range' },  -- , has = 'rangeFormatting'
		{ '<Leader>cr', vim.lsp.buf.rename, desc = 'Rename', has = 'rename' },
		{ '<Leader>ce', vim.diagnostic.open_float, desc = 'Open diagnostics' },
		{ '<Leader>ca', vim.lsp.buf.code_action, mode = { 'n', 'x' }, has = 'codeAction', desc = 'Code Action' },
		{ '<Leader>cA', function()
			vim.lsp.buf.code_action({
				context = {
					only = { 'source' },
					diagnostics = {},
				},
			})
		end, desc = 'Source Action', has = 'codeAction' },
	}
	return M._keys
end

---@param method string
function M.has(buffer, method)
	method = method:find('/') and method or 'textDocument/' .. method
	local clients
	if vim.lsp.get_clients ~= nil then
		clients = vim.lsp.get_clients({ bufnr = buffer })
	else
		---@diagnostic disable-next-line: deprecated
		clients = vim.lsp.get_active_clients({ bufnr = buffer })
	end
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

---@param buffer integer
function M.resolve(buffer)
	local Keys = require('lazy.core.handler.keys')
	local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

	local function add(keymap)
		local keys = Keys.parse(keymap)
		if keys[2] == false then
			keymaps[keys.id] = nil
		else
			keymaps[keys.id] = keys
		end
	end
	for _, keymap in ipairs(M.get()) do
		add(keymap)
	end

	local opts = require('rafi.lib.utils').opts('nvim-lspconfig')
	local clients
	if vim.lsp.get_clients ~= nil then
		clients = vim.lsp.get_clients({ bufnr = buffer })
	else
		---@diagnostic disable-next-line: deprecated
		clients = vim.lsp.get_active_clients({ bufnr = buffer })
	end
	for _, client in ipairs(clients) do
		local maps = opts.servers[client.name] and opts.servers[client.name].keys
			or {}
		for _, keymap in ipairs(maps) do
			add(keymap)
		end
	end
	return keymaps
end

---@param client lsp.Client
---@param buffer integer
function M.on_attach(client, buffer)
	local Keys = require('lazy.core.handler.keys')
	local keymaps = M.resolve(buffer)

	for _, keys in pairs(keymaps) do
		if not keys.has or M.has(buffer, keys.has) then
			local opts = Keys.opts(keys)
			---@diagnostic disable-next-line: no-unknown
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer
			vim.keymap.set(keys.mode or 'n', keys[1], keys[2], opts)
		end
	end
end

-- Toggle diagnostics locally (false) or globally (true).
---@param global boolean
function M.diagnostic_toggle(global)
	local bufnr, cmd, msg, state
	if global then
		bufnr = nil
		state = vim.g.diagnostics_disabled
		vim.g.diagnostics_disabled = not state
	else
		bufnr = 0
		if vim.fn.has('nvim-0.9') == 1 then
			state = vim.diagnostic.is_disabled(bufnr)
		else
			state = vim.b.diagnostics_disabled
			vim.b.diagnostics_disabled = not state
		end
	end

	cmd = state and 'enable' or 'disable'
	msg = cmd:gsub('^%l', string.upper) .. 'd diagnostics'
	if global then
		msg = msg .. ' globally'
	end
	vim.notify(msg)
	vim.schedule(function()
		vim.diagnostic[cmd](bufnr)
	end)
end

---@param next boolean
---@param severity string|nil
---@return fun()
function M.diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	local severity_int = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity_int })
	end
end

return M
