-- Health
-- https://github.com/rafi/vim-config
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/health.lua

local M = {}

-- Returns rafi.json's `field` if it's a list of strings (empty if unset).
-- Otherwise reports an error and returns nil, so a bad hand edit can't crash
-- the checks below (rafi.config falls back to the default for that field).
---@param data table
---@param field string
---@return string[]?
local function list_field(data, field)
	local value = data[field]
	if value == nil then
		return {}
	end
	if type(value) == 'table' and vim.islist(value) then
		local all_strings = true
		for _, item in ipairs(value) do
			if type(item) ~= 'string' then
				all_strings = false
				break
			end
		end
		if all_strings then
			return value
		end
	end
	vim.health.error(
		('`rafi.json` field `%s` must be a list of strings'):format(field)
	)
	return nil
end

-- Reports whether rafi.json exists and parses, and lists extras in it
-- that match no file under lua/rafi/extras/ (typos or unported extras).
-- Reads the file directly, since rafi.config.state() would write a missing
-- one.
local function check_rafi_json()
	local config = require('rafi.config')
	local path = config.json_path()
	if not vim.uv.fs_stat(path) then
		vim.health.warn(('`rafi.json` not found: %s'):format(path))
		return
	end
	local ok_read, lines = pcall(vim.fn.readfile, path)
	local ok, data = false, nil
	if ok_read then
		ok, data = pcall(vim.json.decode, table.concat(lines, '\n'))
	end
	if not ok or type(data) ~= 'table' then
		vim.health.error(('`rafi.json` does not parse: %s'):format(path))
		return
	end
	vim.health.ok(('`rafi.json` parses: %s'):format(path))
	local extras = list_field(data, 'extras')
	local unknown = {}
	for _, name in ipairs(extras or {}) do
		if not require('rafi.extras').find(config.aliases[name] or name) then
			table.insert(unknown, name)
		end
	end
	if #unknown > 0 then
		vim.health.warn(
			('Unknown extras in `rafi.json`: %s'):format(table.concat(unknown, ', '))
		)
	elseif extras then
		vim.health.ok('All extras in `rafi.json` exist')
	end
	for _, name in ipairs(list_field(data, 'disabled') or {}) do
		if vim.list_contains(config.required, name) then
			vim.health.warn(
				('`%s` is required, its entry in `rafi.json` `disabled` is ignored'):format(
					name
				)
			)
		end
	end
end

local nvim_min_ver = '0.12.0'

function M.check()
	vim.health.start('rafi')

	if vim.fn.has('nvim-' .. nvim_min_ver) == 1 then
		vim.health.info(('Neovim version: %s'):format(vim.version()))
		vim.health.ok(('Using Neovim >= %s'):format(nvim_min_ver))
	else
		vim.health.error(
			('Neovim >= %s is required'):format(nvim_min_ver),
			{ 'Upgrade Neovim to latest version.' }
		)
	end

	if vim.pack then
		vim.health.ok('vim.pack available')
	else
		vim.health.error('vim.pack is not available', {
			'Upgrade Neovim to 0.12 or later.',
		})
	end

	check_rafi_json()

	-- stylua: ignore
	local optionals = {
		'git', 'rg', 'bat', { 'fd', 'fdfind' }, 'lazygit', 'zoxide',
	}

	for _, cmd in ipairs(optionals) do
		local name = type(cmd) == 'string' and cmd or vim.inspect(cmd)
		local commands = type(cmd) == 'string' and { cmd } or cmd
		---@cast commands string[]
		local found = false

		for _, c in ipairs(commands) do
			if vim.fn.executable(c) == 1 then
				name = c
				found = true
			end
		end

		if found then
			vim.health.ok(('`%s` is installed'):format(name))
		else
			vim.health.warn(('`%s` is not installed'):format(name))
		end
	end
end

return M
