-- LSP: Key-maps
-- https://github.com/rafi/vim-config

local M = {}

---@param client lsp.Client
---@param buffer integer
function M.get(client, buffer)
	local format = function()
		require('rafi.plugins.lsp.format').format({ force = true })
	end
	local function map(mode, lhs, rhs, user_opts)
		local opts = { buffer = buffer, noremap = true, silent = true }
		opts = vim.tbl_extend('force', opts, user_opts or {})
		if not opts.has or client.server_capabilities[opts.has .. 'Provider'] then
			opts.has = nil
			vim.keymap.set(mode, lhs, rhs, opts)
		end
	end

	-- Keyboard mappings
	map('n', '<leader>cl', '<cmd>LspInfo<cr>')

	map('n', 'gD', vim.lsp.buf.declaration, { has = 'declaration' })
	map('n', 'gd', vim.lsp.buf.definition, { has = 'definition' })
	map('n', 'gr', vim.lsp.buf.references, { has = 'references' })
	map('n', 'gy', vim.lsp.buf.type_definition, { has = 'typeDefinition' })
	map('n', 'gi', vim.lsp.buf.implementation, { has = 'implementation' })

	map('n', ',rn', vim.lsp.buf.rename, { has = 'rename' })
	map('n', ',s', vim.lsp.buf.signature_help, { has = 'signatureHelp' })
	map('n', ',wa', vim.lsp.buf.add_workspace_folder)
	map('n', ',wr', vim.lsp.buf.remove_workspace_folder)
	map('n', ',wl', '<cmd>lua =vim.lsp.buf.list_workspace_folders()<CR>')

	map({'n', 'x'}, ',f', format, { has = 'documentFormatting' })

	map('n', 'K', function()
		local winid = require('rafi.config').has('nvim-ufo')
			and require('ufo').peekFoldedLinesUnderCursor() or nil
		if not winid then
			vim.lsp.buf.hover()
		end
	end)

	map(
		{'n', 'x'},
		'<Leader>ca',
		vim.lsp.buf.code_action,
		{ has = 'codeAction', desc = 'Code Action' }
	)
	map(
		'n',
		'<Leader>ce',
		vim.diagnostic.open_float,
		{ desc = 'Open diagnostics' }
	)

	if not require('rafi.config').has('mini.bracketed') then
		map('n', ']d', M.diagnostic_goto(true))
		map('n', '[d', M.diagnostic_goto(false))
	end
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
