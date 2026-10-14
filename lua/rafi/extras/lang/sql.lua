-- SQL: vim-dadbod stack (:DBUI, <leader>D), dadbod completion, sqlfluff
-- Define connections with `vim.g.dbs`, e.g. in lua/config/options.lua:
--   vim.g.dbs = { dev = 'url', staging = 'url' }
-- or a list of `{ name = 'dev', url = 'url' }`. Keep secrets out of git.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/sql.lua
local pack = require('rafi.pack')

local sql_ft = { 'sql', 'mysql', 'plsql' }

-- Turn off the built-in SQL completion so blink.cmp's omni works. Keywords
-- still come from syntax.
vim.g.omni_sql_default_compl_type = 'syntax'
vim.g.loaded_sql_completion = true

require('rafi.util.lang').add({
	servers = { sqlls = true },
	tools = { 'sqlfluff' },
	linters_by_ft = {
		sql = { 'sqlfluff' },
		mysql = { 'sqlfluff' },
		plsql = { 'sqlfluff' },
	},
	formatters_by_ft = {
		sql = { 'sqlfluff' },
		mysql = { 'sqlfluff' },
		plsql = { 'sqlfluff' },
	},
})
local format = require('rafi.util.format')
format.opts.formatters = format.opts.formatters or {}
format.opts.formatters.sqlfluff = {
	args = { 'format', '--dialect=ansi', '-' },
}

-- Completion source for dadbod, enabled for SQL filetypes only.
require('rafi.util.blink').add_source('dadbod', {
	name = 'Dadbod',
	module = 'vim_dadbod_completion.blink',
}, sql_ft)

vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_save_location = vim.fn.stdpath('data') .. '/dadbod_ui'
vim.g.db_ui_show_database_icon = true
vim.g.db_ui_tmp_query_location = vim.fn.stdpath('data') .. '/dadbod_ui/tmp'
vim.g.db_ui_use_nerd_fonts = true
vim.g.db_ui_use_nvim_notify = true
-- Running queries on save is off: a big query can crash Neovim each time
-- you write. Use the default keymap <leader>S to run it.
vim.g.db_ui_execute_on_save = false

local db_loaded = false
local function load_db()
	if db_loaded then
		return
	end
	db_loaded = true
	vim.pack.add({
		'https://github.com/tpope/vim-dadbod',
		'https://github.com/kristijanhusak/vim-dadbod-completion',
	})
end

local ui_loaded = false
local function load_ui()
	if ui_loaded then
		return
	end
	ui_loaded = true
	vim.pack.add({
		'https://github.com/tpope/vim-dadbod',
		'https://github.com/kristijanhusak/vim-dadbod-ui',
	})
end

-- Load on SQL files so the dadbod completion source is available.
pack.on_filetype(table.concat(sql_ft, ','), load_db)

pack.command('DB', load_db, { nargs = '*', range = true, complete = true })
pack.command(
	{ 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
	load_ui
)

vim.keymap.set('n', '<leader>D', function()
	load_ui()
	vim.cmd('DBUIToggle')
end, { desc = 'Toggle DBUI' })
