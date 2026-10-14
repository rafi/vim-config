-- Python formatter: black
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/formatting/black.lua
local format = require('rafi.util.format')
local lang = require('rafi.util.lang')

-- Add black to python's formatters, keeping ones other extras added.
local current = lang.formatters_by_ft.python
	or format.opts.formatters_by_ft.python
	or {}
local list = vim.list_extend({}, type(current) == 'table' and current or {})
if not vim.tbl_contains(list, 'black') then
	table.insert(list, 'black')
end

lang.add({
	tools = { 'black' },
	formatters_by_ft = { python = list },
})
