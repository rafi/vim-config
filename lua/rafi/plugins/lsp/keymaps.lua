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
		{ 'gD', vim.lsp.buf.declaration, desc = 'Goto Declaration' },
		{ 'gI', vim.lsp.buf.implementation, desc = 'Goto Implementation' },
		{ 'gy', vim.lsp.buf.type_definition, desc = 'Goto Type Definition' },
		{ 'K', function() return vim.lsp.buf.hover() end, desc = 'Hover' },
		{ 'gK', function() return vim.lsp.buf.signature_help() end, desc = 'Signature Help' },

		{ '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File', mode = {'n'}, has = { 'workspace/didRenameFiles', 'workspace/willRenameFiles' }},
		{ '<leader>cr', vim.lsp.buf.rename, desc = 'Rename', has = 'rename' },
		{ '<Leader>ca', vim.lsp.buf.code_action, mode = { 'n', 'x' }, has = 'codeAction', desc = 'Code Action' },
		{ '<leader>cc', vim.lsp.codelens.run, desc = 'Run Codelens', mode = { 'n', 'x' }, has = 'codeLens' },
		{ '<leader>cC', vim.lsp.codelens.refresh, desc = 'Refresh & Display Codelens', mode = { 'n' }, has = 'codeLens' },
		{ '<leader>cA', LazyVim.lsp.action.source, desc = 'Source Action', has = 'codeAction' },

		{ ']]', function() Snacks.words.jump(vim.v.count1) end, has = 'documentHighlight',
			desc = 'Next Reference', cond = function() return Snacks.words.is_enabled() end },
		{ '[[', function() Snacks.words.jump(-vim.v.count1) end, has = 'documentHighlight',
			desc = 'Prev Reference', cond = function() return Snacks.words.is_enabled() end },
		{ '<a-n>', function() Snacks.words.jump(vim.v.count1, true) end, has = 'documentHighlight',
			desc = 'Next Reference', cond = function() return Snacks.words.is_enabled() end },
		{ '<a-p>', function() Snacks.words.jump(-vim.v.count1, true) end, has = 'documentHighlight',
			desc = 'Prev Reference', cond = function() return Snacks.words.is_enabled() end },

		{ '<leader>cil', '<cmd>LspInfo<cr>', desc = 'LSP info popup' },
		{ '<leader>csf', M.formatter_select, mode = { 'n', 'x' }, desc = 'Formatter Select' },
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
	local spec = M.get()
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

function M.on_detach(_, buffer)
	local keymaps = M.resolve(buffer)
	vim.notify('Detaching keymaps for buffer ' .. buffer, vim.log.levels.INFO)
	for _, keys in pairs(keymaps) do
		if not keys.has or M.has(buffer, keys.has) then
			local opts = { buffer = buffer }
			local ok = pcall(vim.keymap.del, keys.mode or 'n', keys.lhs, opts)
			if not ok then
				vim.notify(
					'Failed to remove keymap: ' .. keys.lhs,
					vim.log.levels.ERROR
				)
			end
		end
	end
end

-- Display a list of formatters and apply the selected one.
function M.formatter_select()
	local buf = vim.api.nvim_get_current_buf()
	local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, vim.fn.mode())
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
	local fmts = LazyVim.format.resolve(buf)
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
		LazyVim.try(function()
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
