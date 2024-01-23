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
		{ 'gr', vim.lsp.buf.references, desc = 'References' },
		{ 'gd', vim.lsp.buf.definition, desc = 'Goto Definition', has = 'definition' },
		{ 'gD', vim.lsp.buf.declaration, desc = 'Goto Declaration' },
		{ 'gI', vim.lsp.buf.implementation, desc = 'Goto Implementation' },
		{ 'gy', vim.lsp.buf.type_definition, desc = 'Goto Type Definition' },
		{ 'gK', vim.lsp.buf.signature_help, desc = 'Signature Help' },

		{ '<Leader>fwa', vim.lsp.buf.add_workspace_folder, desc = 'Show Workspace Folders' },
		{ '<Leader>fwr', vim.lsp.buf.remove_workspace_folder, desc = 'Remove Workspace Folder' },
		{ '<Leader>fwl', '<cmd>lua =vim.lsp.buf.list_workspace_folders()<CR>', desc = 'List Workspace Folders' },

		{ 'K', function()
			-- Show hover documentation or folded lines.
			local winid = require('lazyvim.util').has('nvim-ufo')
				and require('ufo').peekFoldedLinesUnderCursor() or nil
			if not winid then
				vim.lsp.buf.hover()
			end
		end },

		{ '<Leader>ud', function() M.diagnostic_toggle(false) end, desc = 'Disable Diagnostics' },
		{ '<Leader>uD', function() M.diagnostic_toggle(true) end, desc = 'Disable All Diagnostics' },

		{ '<leader>cl', '<cmd>LspInfo<cr>', desc = 'LSP info popup' },
		{ '<leader>cs', M.formatter_select, mode = { 'n', 'x' }, desc = 'Formatter Select' },
		{ '<Leader>chi', vim.lsp.buf.incoming_calls, desc = 'Incoming calls' },
		{ '<Leader>cho', vim.lsp.buf.outgoing_calls, desc = 'Outgoing calls' },
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
	if require('lazyvim.util').has('inc-rename.nvim') then
		M._keys[#M._keys + 1] = {
			'<leader>cr',
			function()
				local inc_rename = require('inc_rename')
				return string.format(
					':%s %s',
					inc_rename.config.cmd_name,
					vim.fn.expand('<cword>')
				)
			end,
			expr = true,
			desc = 'Rename',
			has = 'rename',
		}
	else
		M._keys[#M._keys + 1] = {
			'<leader>cr',
			vim.lsp.buf.rename,
			desc = 'Rename',
			has = 'rename',
		}
	end
	return M._keys
end

---@param method string
function M.has(buffer, method)
	method = method:find('/') and method or 'textDocument/' .. method
	local clients = require('lazyvim.util').lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

---@return (LazyKeys|{has?:string})[]
function M.resolve(buffer)
	local Keys = require('lazy.core.handler.keys')
	if not Keys.resolve then
		return {}
	end
	local spec = M.get()
	local opts = require('lazyvim.util').opts('nvim-lspconfig')
	local clients = require('lazyvim.util').lsp.get_clients({ bufnr = buffer })
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
		if not keys.has or M.has(buffer, keys.has) then
			---@class LazyKeysBase
			local opts = Keys.opts(keys)
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer
			vim.keymap.set(keys.mode or 'n', keys.lhs, keys.rhs, opts)
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

-- Display a list of formatters and apply the selected one.
function M.formatter_select()
	local buf = vim.api.nvim_get_current_buf()
	local mode = vim.fn.mode()
	local is_visual = mode == 'v' or mode == 'V' or mode == ''
	local cur_start, cur_end
	if is_visual then
		cur_start = vim.fn.getpos('.')
		cur_end = vim.fn.getpos('v')
	end

	-- Collect various sources of formatters.
	---@class rafi.Formatter
	---@field kind string
	---@field name string
	---@field client LazyFormatter|{active:boolean,resolved:string[]}

	---@type rafi.Formatter[]
	local sources = {}
	local fmts = require('lazyvim.util.format').resolve(buf)
	for _, fmt in ipairs(fmts) do
		vim.tbl_map(function(resolved)
			table.insert(sources, {
				kind = fmt.name,
				name = resolved,
				client = fmt,
			})
		end, fmt.resolved)
	end

	local total_sources = #sources

	-- Apply formatter source on buffer.
	---@param bufnr number
	---@param source rafi.Formatter
	local apply_source = function(bufnr, source)
		if source == nil then
			return
		end
		require('lazyvim.util').try(function()
			return source.client.format(bufnr)
		end, { msg = 'Formatter `' .. source.name .. '` failed' })
	end

	if total_sources == 1 then
		apply_source(buf, sources[1])
	elseif total_sources > 1 then
		-- Display a list of sources to choose from
		vim.ui.select(sources, {
			prompt = 'Select a formatter',
			format_item = function(item)
				return item.name .. ' (' .. item.kind .. ')'
			end,
		}, function(selected)
			if is_visual then
				-- Restore visual selection
				vim.fn.setpos('.', cur_start)
				vim.cmd([[normal! v]])
				vim.fn.setpos('.', cur_end)
			end
			apply_source(buf, selected)
		end)
	else
		vim.notify(
			'No configured formatters for this filetype.',
			vim.log.levels.WARN
		)
	end
end

return M
