-- LSP: Key-maps
-- https://github.com/rafi/vim-config

local M = {}

---@param client lsp.Client
---@param buffer integer
function M.get(client, buffer)
	local format = require('rafi.plugins.lsp.format').format
	local function map(mode, lhs, rhs, user_opts)
		local opts = { buffer = buffer, noremap = true, silent = true }
		opts = vim.tbl_extend('force', opts, user_opts or {})
		if not opts.has or client.server_capabilities[opts.has .. 'Provider'] then
			opts.has = nil
			vim.keymap.set(mode, lhs, rhs, opts)
		end
	end

	-- Keyboard mappings
	map('n', 'K', vim.lsp.buf.hover)
	map('n', '<leader>cl', '<cmd>LspInfo<cr>')

	map('n', 'gD', vim.lsp.buf.declaration)
	map('n', 'gd', vim.lsp.buf.definition)
	map('n', 'gr', vim.lsp.buf.references)
	map('n', 'gy', vim.lsp.buf.type_definition)
	map('n', 'gi', vim.lsp.buf.implementation)

	map('n', ',rn', vim.lsp.buf.rename, { has = 'rename' })
	map('n', ',s', vim.lsp.buf.signature_help, { has = 'signatureHelp' })
	map('n', ',wa', vim.lsp.buf.add_workspace_folder)
	map('n', ',wr', vim.lsp.buf.remove_workspace_folder)
	map('n', ',wl', '<cmd>lua =vim.lsp.buf.list_workspace_folders()<CR>')

	map('n', ',f', format, { has = 'documentFormatting' })
	map('x', ',f', format, { has = 'documentRangeFormatting' })

	map(
		{'n', 'x'},
		'<Leader>ca',
		vim.lsp.buf.code_action,
		{ has = 'codeAction', desc = 'Code Action' }
	)
	map('n', '<Leader>ce', vim.diagnostic.open_float)

	map('n', ']e', M.diagnostic_goto(true, 'ERROR'))
	map('n', '[e', M.diagnostic_goto(false, 'ERROR'))

	map('n', '<Leader>tp', function()
		M.diagnostic_toggle(false)
	end, { desc = 'Disable Diagnostics' })
	map('n', '<Leader>tP', function()
		M.diagnostic_toggle(true)
	end, { desc = 'Disable All Diagnostics' })
end

-- Toggle diagnostics locally (false) or globally (true).
---@param global boolean
function M.diagnostic_toggle(global)
	local vars, bufnr, cmd, msg
	if global then
		vars = vim.g
		bufnr = nil
	else
		vars = vim.b
		bufnr = 0
	end
	vars.diagnostics_disabled = not vars.diagnostics_disabled
	if vars.diagnostics_disabled then
		cmd = 'disable'
		msg = 'Disabling diagnostics'
	else
		cmd = 'enable'
		msg = 'Enabling diagnostics'
	end
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
function M.diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	local severity_int = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity_int })
	end
end

---@param client lsp.Client
---@param buffer integer
function M.on_attach(client, buffer)
	M.get(client, buffer)
end

return M
