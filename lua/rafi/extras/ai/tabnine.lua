-- Tabnine AI completion as a blink.cmp source (via cmp-tabnine, downloads its binary on install)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/tabnine.lua
local blink = require('rafi.util.blink')

-- Make a blink.cmp transform that shows items with a custom kind `name`.
---@param name string
---@return fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
local function custom_kind(name)
	local idx ---@type integer?
	return function(_, items)
		if not idx then
			local kinds = require('blink.cmp.types').CompletionItemKind
			idx = #kinds + 1
			kinds[idx] = name
		end
		for _, item in ipairs(items) do
			item.kind = idx
			item.kind_name = name
		end
		return items
	end
end
local pack = require('rafi.pack')

-- cmp-tabnine is an nvim-cmp source, blink.compat adapts it.
blink.add_source('cmp_tabnine', {
	name = 'cmp_tabnine',
	module = 'blink.compat.source',
	transform_items = custom_kind('TabNine'),
	score_offset = 100,
	async = true,
})

-- cmp-tabnine downloads the TabNine binary with its install script.
pack.build('cmp-tabnine', {
	build = function(path)
		local cmd = vim.fn.has('win32') == 1
				and { 'pwsh', '-noni', '.\\install.ps1' }
			or { './install.sh' }
		local res = vim.system(cmd, { cwd = path }):wait()
		if res.code ~= 0 then
			vim.notify(
				'cmp-tabnine install failed:\n' .. (res.stderr or ''),
				vim.log.levels.ERROR
			)
		end
	end,
	is_built = function(path)
		return vim.uv.fs_stat(path .. '/binaries') ~= nil
	end,
})

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/saghen/blink.compat',
		'https://github.com/tzachar/cmp-tabnine',
	})
	require('cmp_tabnine.config'):setup({
		max_lines = 1000,
		max_num_results = 3,
		sort = true,
	})
end

pack.on_event('InsertEnter', load)
