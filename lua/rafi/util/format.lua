-- Formatting on top of conform.nvim
-- https://github.com/rafi/vim-config
--
-- Autoformat follows `vim.g.autoformat` and `vim.b.autoformat`. conform runs
-- with `lsp_format = 'fallback'`, so LSP formats only when conform has no
-- formatters for the buffer.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/format.lua

---@class rafi.util.format
---@overload fun(opts?: {force?: boolean, buf?: integer})
local M = setmetatable({}, {
	__call = function(m, ...)
		return m.format(...)
	end,
})

---@class rafi.util.format.Resolved
---@field name string
---@field active boolean
---@field resolved string[]
---@field format fun(buf: integer)

-- conform.nvim options, merged with rafi.util.lang formatters on load.
---@type conform.setupOpts
M.opts = {
	default_format_opts = {
		timeout_ms = 3000,
		async = false, -- not recommended to change
		quiet = false, -- not recommended to change
		lsp_format = 'fallback', -- not recommended to change
	},
	formatters_by_ft = {
		lua = { 'stylua' },
		fish = { 'fish_indent' },
		sh = { 'shfmt' },
		-- lua/rafi/extras/lang/<lang>.lua files add theirs, see rafi.util.lang
	},
	formatters = {
		injected = { options = { ignore_errors = true } },
	},
}

local loaded = false

---Add and setup conform.nvim, once.
function M.load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })
	M.opts.formatters_by_ft = vim.tbl_extend(
		'force',
		M.opts.formatters_by_ft,
		require('rafi.util.lang').formatters_by_ft
	)
	require('conform').setup(M.opts)
end

function M.formatexpr()
	M.load()
	return require('conform').formatexpr()
end

---@param buf? integer
---@return rafi.util.format.Resolved[]
function M.resolve(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	M.load()
	local conform = require('conform')
	local conform_names = vim.tbl_map(function(v)
		return v.name
	end, conform.list_formatters(buf))

	local clients = vim.tbl_filter(function(client)
		return client:supports_method('textDocument/formatting')
			or client:supports_method('textDocument/rangeFormatting')
	end, vim.lsp.get_clients({ bufnr = buf }))
	local lsp_names = vim.tbl_map(function(client)
		return client.name
	end, clients)

	return {
		{
			name = 'conform.nvim',
			active = #conform_names > 0,
			resolved = conform_names,
			format = function(b)
				require('conform').format({ bufnr = b })
			end,
		},
		{
			name = 'LSP',
			active = #conform_names == 0 and #lsp_names > 0,
			resolved = lsp_names,
			format = function(b)
				vim.lsp.buf.format({ bufnr = b })
			end,
		},
	}
end

---@param buf? integer
function M.info(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local gaf = vim.g.autoformat == nil or vim.g.autoformat
	local baf = vim.b[buf].autoformat
	local enabled = M.enabled(buf)
	local lines = {
		'# Status',
		('- [%s] global **%s**'):format(
			gaf and 'x' or ' ',
			gaf and 'enabled' or 'disabled'
		),
		('- [%s] buffer **%s**'):format(
			enabled and 'x' or ' ',
			baf == nil and 'inherit' or baf and 'enabled' or 'disabled'
		),
	}
	local have = false
	for _, formatter in ipairs(M.resolve(buf)) do
		if #formatter.resolved > 0 then
			have = true
			lines[#lines + 1] = '\n# '
				.. formatter.name
				.. (formatter.active and ' ***(active)***' or '')
			for _, line in ipairs(formatter.resolved) do
				lines[#lines + 1] = ('- [%s] **%s**'):format(
					formatter.active and 'x' or ' ',
					line
				)
			end
		end
	end
	if not have then
		lines[#lines + 1] = '\n***No formatters available for this buffer.***'
	end
	vim.notify(
		table.concat(lines, '\n'),
		enabled and vim.log.levels.INFO or vim.log.levels.WARN,
		{ title = 'Format (' .. (enabled and 'enabled' or 'disabled') .. ')' }
	)
end

---@param buf? integer
---@return boolean
function M.enabled(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local gaf = vim.g.autoformat
	local baf = vim.b[buf].autoformat

	-- If the buffer has a local value, use that
	if baf ~= nil then
		return baf
	end

	-- Otherwise use the global value if set, or true by default
	return gaf == nil or gaf
end

---@param buf? boolean
function M.toggle(buf)
	M.enable(not M.enabled(), buf)
end

---@param enable? boolean
---@param buf? boolean
function M.enable(enable, buf)
	if enable == nil then
		enable = true
	end
	if buf then
		vim.b.autoformat = enable
	else
		vim.g.autoformat = enable
		vim.b.autoformat = nil
	end
	M.info()
end

---@param opts? {force?: boolean, buf?: integer}
function M.format(opts)
	opts = opts or {}
	local buf = opts.buf or vim.api.nvim_get_current_buf()
	if not (opts.force or M.enabled(buf)) then
		return
	end

	local done = false
	for _, formatter in ipairs(M.resolve(buf)) do
		if formatter.active then
			done = true
			local ok, err = pcall(formatter.format, buf)
			if not ok then
				vim.notify(
					('Formatter `%s` failed\n%s'):format(formatter.name, err),
					vim.log.levels.ERROR,
					{ title = 'Format' }
				)
			end
		end
	end

	if not done and opts.force then
		vim.notify(
			'No formatter available',
			vim.log.levels.WARN,
			{ title = 'Format' }
		)
	end
end

---@param buf? boolean
function M.snacks_toggle(buf)
	return Snacks.toggle({
		name = 'Auto Format (' .. (buf and 'Buffer' or 'Global') .. ')',
		get = function()
			if not buf then
				return vim.g.autoformat == nil or vim.g.autoformat
			end
			return M.enabled()
		end,
		set = function(state)
			M.enable(state, buf)
		end,
	})
end

local did_setup = false

---Create the autoformat autocmd and :Format/:FormatInfo commands, once.
function M.setup()
	if did_setup then
		return
	end
	did_setup = true

	vim.api.nvim_create_autocmd('BufWritePre', {
		group = vim.api.nvim_create_augroup('RafiFormat', { clear = true }),
		callback = function(ev)
			M.format({ buf = ev.buf })
		end,
	})

	vim.api.nvim_create_user_command('Format', function()
		M.format({ force = true })
	end, { desc = 'Format selection or buffer' })

	vim.api.nvim_create_user_command('FormatInfo', function()
		M.info()
	end, { desc = 'Show info about the formatters for the current buffer' })
end

return M
