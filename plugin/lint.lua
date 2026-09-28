-- Asynchronous linter plugin, reports via vim.diagnostic
if require('rafi.config').disabled('lint') then
	return
end

-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/linting.lua

local pack = require('rafi.pack')

local opts = {
	-- Events to trigger linters
	events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
	linters_by_ft = {
		fish = { 'fish' },
		-- lua/rafi/extras/lang/<lang>.lua files add theirs, see rafi.util.lang
		-- Use the "*" filetype to run linters on all filetypes.
		-- ['*'] = { 'global linter' },
		-- Use the "_" filetype to run linters on filetypes that don't have
		-- other linters configured.
		-- ['_'] = { 'fallback linter' },
	},
	-- Override linter options or add custom linters. Supports
	-- `prepend_args` and `condition = function(ctx)` (ctx: filename, dirname).
	---@type table<string,table>
	linters = {},
}

local function list_prepend(dst, src)
	for i = 1, #src do
		table.insert(dst, i, src[i])
	end
end

local function debounce(ms, fn)
	local timer = assert(vim.uv.new_timer())
	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

local function lint()
	local nvim_lint = require('lint')
	-- Use nvim-lint's logic first:
	-- * checks if linters exist for the full filetype first
	-- * otherwise will split filetype by "." and add all those linters
	-- * this differs from conform.nvim which only uses the first filetype
	--   that has a formatter
	local names = nvim_lint._resolve_linter_by_ft(vim.bo.filetype)

	-- Create a copy of the names table to avoid modifying the original.
	names = vim.list_extend({}, names)

	-- Add fallback linters.
	if #names == 0 then
		vim.list_extend(names, nvim_lint.linters_by_ft['_'] or {})
	end

	-- Add global linters.
	vim.list_extend(names, nvim_lint.linters_by_ft['*'] or {})

	-- Filter out linters that don't exist or don't match the condition.
	local ctx = { filename = vim.api.nvim_buf_get_name(0) }
	ctx.dirname = vim.fn.fnamemodify(ctx.filename, ':h')
	names = vim.tbl_filter(function(name)
		local linter = nvim_lint.linters[name]
		if not linter then
			vim.notify(
				'Linter not found: ' .. name,
				vim.log.levels.WARN,
				{ title = 'nvim-lint' }
			)
		end
		return linter
			and not (
				type(linter) == 'table'
				and linter.condition
				and not linter.condition(ctx)
			)
	end, names)

	-- Run linters.
	if #names > 0 then
		nvim_lint.try_lint(names)
	end
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/mfussenegger/nvim-lint' })
	local nvim_lint = require('lint')
	for name, linter in pairs(opts.linters) do
		if type(linter) == 'table' and type(nvim_lint.linters[name]) == 'table' then
			nvim_lint.linters[name] =
				vim.tbl_deep_extend('force', nvim_lint.linters[name], linter)
			if type(linter.prepend_args) == 'table' then
				nvim_lint.linters[name].args = nvim_lint.linters[name].args or {}
				list_prepend(nvim_lint.linters[name].args, linter.prepend_args)
			end
		else
			nvim_lint.linters[name] = linter
		end
	end
	nvim_lint.linters_by_ft = vim.tbl_extend(
		'force',
		opts.linters_by_ft,
		require('rafi.util.lang').linters_by_ft
	)

	local debounced = debounce(100, lint)
	vim.api.nvim_create_autocmd(opts.events, {
		group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
		callback = debounced,
	})
	-- The triggering BufReadPost already fired, lint it now.
	debounced()
end

pack.on_event('BufReadPost,BufNewFile', load)

vim.keymap.set('n', '<leader>cin', function()
	load()
	vim.notify(vim.inspect(require('lint').linters[vim.bo.filetype]))
end, { silent = true, desc = 'Linter Info' })
