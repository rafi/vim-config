-- Display list of formatters to choose from and auto-format on save.
-- https://github.com/rafi/vim-config

-- Based on: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/format.lua

local M = {}

---@class rafi.Formatter
---@field kind string
---@field name string
---@field client lsp.Client|table|function

---@class PluginLspOpts
M.opts = {}

-- Is autoformat enabled?
function M.enabled()
	return M.opts.autoformat
end

-- Toggle autoformat on save.
function M.toggle()
	if vim.b.autoformat == false then
		vim.b.autoformat = nil
		M.opts.autoformat = true
	else
		M.opts.autoformat = not M.opts.autoformat
	end
	local msg = M.opts.autoformat and 'Enabled' or 'Disabled'
	vim.notify(
		msg .. ' format on save',
		vim.log.levels.INFO,
		{ title = 'Formatting' }
	)
end

-- Display a list of formatters and apply the selected one.
---@param user_opts? {force?:boolean, select?:boolean}
function M.format(user_opts)
	local format_opts = vim.tbl_extend('force', M.opts.format, user_opts or {})
	local buf = vim.api.nvim_get_current_buf()
	if vim.b.autoformat == false and not format_opts.force then
		return
	end
	local range = nil
	local mode = vim.fn.mode()
	if mode == 'v' or mode == 'V' or mode == '' then
		range = {}
		_, range[1], _, _ = unpack(vim.fn.getpos('.') or { 0, 0, 0, 0 })
		_, range[2], _, _ = unpack(vim.fn.getpos('v') or { 0, 0, 0, 0 })
		if range[1] == 0 and range[2] == 0 then
			return
		end
	end

	local sources = M.get_formatters(buf, range)
	local total_sources = #sources

	if total_sources > 1 and format_opts.select then
		-- Display a list of sources to choose from
		vim.ui.select(sources, {
			prompt = 'Select a formatter',
			format_item = function(item)
				return item.name .. ' (' .. item.kind .. ')'
			end,
		}, function(source)
			M.apply_source(buf, source, range)
		end)

	elseif total_sources > 0 then
		-- Apply first found source, by priority
		local source = M.filter_sources(sources, format_opts.priority)
		M.apply_source(buf, source, range)
		if format_opts.notify then
			M.notify(sources, source)
		end

	else
		vim.notify('No configured formatters for this filetype.')
	end
end

-- Apply formatter source on buffer.
---@param sources rafi.Formatter[]
---@param kind_priority table<string>
function M.filter_sources(sources, kind_priority)
	for _, kind in ipairs(kind_priority) do
		for _, source in ipairs(sources) do
			if source.kind == kind then
				return source
			end
		end
	end
end

-- Apply formatter source on buffer.
---@param bufnr integer
---@param source rafi.Formatter
---@param range table<integer, integer>|nil
function M.apply_source(bufnr, source, range)
	if source == nil then
		return
	end

	M.supported_kinds[source.kind].apply(bufnr, source, range)
end

-- List the available formatters.
---@param sources rafi.Formatter[]
---@param selected rafi.Formatter
function M.notify(sources, selected)
	local kinds = {}
	for _, source in ipairs(sources) do
		kinds[source.kind] = kinds[source.kind] or {}
		table.insert(kinds[source.kind], source)
	end

	local lines = {}
	for kind, fmts in pairs(kinds) do
		if #lines > 0 then
			table.insert(lines, '')
		end
		table.insert(lines, '# ' .. kind)
		for _, source in ipairs(fmts) do
			local line = '- **' .. source.name .. '**'
			if selected.kind == kind and selected.name == source.name then
				line = line .. ' _<--_'
			end
			table.insert(lines, line)
		end
	end

	vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, {
		title = 'Formatting',
		on_open = function(win)
			local scope = { scope = 'local', win = win }
			vim.api.nvim_set_option_value('conceallevel', 3, scope)
			vim.api.nvim_set_option_value('spell', false, scope)
			local buf = vim.api.nvim_win_get_buf(win)
			vim.treesitter.start(buf, 'markdown')
		end,
	})
end

-- Collect various sources of formatters:
-- 1. LSP clients that support formatting
-- 2. formatter.nvim sources
-- 3. null-ls sources (null-ls is registered as an lsp client)
---@param bufnr integer
---@param range table<integer, integer>|nil
function M.get_formatters(bufnr, range)
	---@type rafi.Formatter[]
	local sources = {}

	for kind, util in pairs(M.supported_kinds) do
		local items = util.finder(kind, bufnr, range)
		for _, item in ipairs(items) do
			table.insert(sources, item)
		end
	end
	return sources
end

-- Get all LSP clients that support formatting,
-- and have not disabled it in their client config.
---@param client lsp.Client
---@param range table<integer, integer>|nil
function M.supports_format(client, range)
	if
		client.config
		and client.config.capabilities
		and client.config.capabilities['documentFormattingProvider'] == false
	then
		return false
	end
	if range and client.supports_method('textDocument/rangeFormatting') then
		return true
	elseif not range and client.supports_method('textDocument/formatting') then
		return true
	end
	return false
end

-- Setup this formatter manager
---@param opts PluginLspOpts
function M.setup(opts)
	M.opts = opts
	vim.api.nvim_create_autocmd('BufWritePre', {
		group = vim.api.nvim_create_augroup('rafi_format', {}),
		callback = function()
			if M.opts.autoformat then
				M.format()
			end
		end,
	})
end

M.supported_kinds = {

	-- Collect LSP clients supporting formatting.
	lsp = {
		-- This is also the default 'apply' for kinds that don't define one.
		---@param bufnr integer
		---@param source rafi.Formatter
		---@param range table<integer, integer>|nil
		apply = function(bufnr, source, range)
			vim.lsp.buf.format(vim.tbl_deep_extend('force', {
				bufnr = bufnr,
				id = source.client.id,
				range = range,
			}, M.opts.format.lsp))
		end,
		---@param kind string
		---@param bufnr integer
		---@param range table<integer, integer>|nil
		finder = function(kind, bufnr, range)
			---@type rafi.Formatter[]
			local sources = {}
			local clients
			if vim.lsp.get_clients ~= nil then
				clients = vim.lsp.get_clients({ bufnr = bufnr })
			else
				---@diagnostic disable-next-line: deprecated
				clients = vim.lsp.get_active_clients({ bufnr = bufnr })
			end
			for _, client in ipairs(clients) do
				if client.name ~= 'null-ls' and M.supports_format(client, range) then
					table.insert(sources, {
						kind = kind,
						name = client.name,
						client = client,
					})
				end
			end
			return sources
		end,
	},

	-- Collect null-ls sources.
	['null-ls'] = {
		---@param bufnr integer
		---@param source rafi.Formatter
		---@param range table<integer, integer>|nil
		apply = function(bufnr, source, range)
			local ft = vim.bo[bufnr].filetype
			local methods = require('null-ls.methods')
			local method = methods.internal.FORMATTING
			local generators = require('null-ls.generators')
			local available =  generators.get_available(ft, method) or {}
			local formatters = {}
			-- Disable other formatters temporarily.
			for _, formatter in ipairs(available) do
				formatters[formatter.opts.command] = formatter
			end
			for command, formatter in pairs(formatters) do
				formatter._disabled = command ~= source.name or nil
			end
			-- Run null-ls formatting.
			vim.lsp.buf.format({ bufnr = bufnr, range = range, name = 'null-ls' })
			-- Enable all formatters back to normal.
			for _, formatter in ipairs(formatters) do
				formatter._disabled = nil
			end
		end,
		---@param kind string
		---@param bufnr integer
		---@param _ table<integer, integer>|nil
		finder = function(kind, bufnr, _)
			if not package.loaded['null-ls'] then
				return {}
			end
			---@type rafi.Formatter[]
			local sources = {}
			local ft = vim.bo[bufnr].filetype
			local fmts =  require('null-ls.sources')
				.get_available(ft, 'NULL_LS_FORMATTING')
			for _, fmt in ipairs(fmts) do
				table.insert(sources, { kind = kind, name = fmt.name, client = fmt })
			end
			return sources
		end,
	},

	-- Collect formatter.nvim sources.
	formatter = {
		---@param bufnr integer
		---@param source rafi.Formatter
		---@param range table<integer, integer>|nil
		apply = function(bufnr, source, range)
			local fmt = require('formatter.format')
			if range == nil then
				range = { 1, vim.fn.line('$') }
			end
			-- TODO: bufnr needs to be supported in formatter/format.start_task(opts)
			fmt.format(source.name, '', range[1], range[2], { buffer = bufnr })
		end,
		---@param kind string
		---@param bufnr integer
		---@param _ table<integer, integer>|nil
		finder = function(kind, bufnr, _)
			if not package.loaded['formatter'] then
				return {}
			end
			---@type rafi.Formatter[]
			local sources = {}
			local ft = vim.bo[bufnr].filetype
			local fmts = require('formatter.util').get_available_formatters_for_ft(ft)
			for _, fmt in ipairs(fmts) do
				if fmt ~= nil then
					table.insert(sources, { kind = kind, name = fmt.exe, client = fmt })
				end
			end
			return sources
		end,
	}
}

return M
