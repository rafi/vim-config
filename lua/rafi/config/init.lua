-- Rafi's Neovim config loader
-- https://github.com/rafi/vim-config
-- ===

-- Boots config and holds the rafi.json extras state.

local M = {}

---Load an optional user file from lua/config/. A missing file is fine;
---errors inside an existing one are reported instead of swallowed.
---@param mod string
local function load_user(mod)
	local ok, err = pcall(require, mod)
	local missing = type(err) == 'string'
		and err:find(("module '%s' not found"):format(mod), 1, true)
	if not ok and not missing then
		vim.notify(
			('Failed loading %s: %s'):format(mod, tostring(err)),
			vim.log.levels.WARN
		)
	end
end

---Load a rafi.config module now, turning an error into a warning (via
---MiniMisc.safely), so one broken module doesn't skip the ones after it.
---@param mod string
local function load_rafi(mod)
	require('rafi.pack').now(function()
		require(mod)
	end)
end

---Load options and autocmds now, keymaps on `later`. Each lua/config/ user
---file loads right after its rafi counterpart, so it can override it.
function M.setup()
	load_rafi('rafi.config.options')
	load_user('config.options')
	-- Defer clipboard (pbcopy/xsel can be slow). Captured after the user's
	-- options.lua, so their value is the one restored on `later`. Skipped if
	-- something set clipboard in between (a plugin/ file, an extra,
	-- lua/plugins/*.lua or config.autocmds), so that value isn't clobbered.
	local clipboard = vim.opt.clipboard:get()
	vim.opt.clipboard = ''
	require('rafi.pack').later(function()
		if vim.o.clipboard == '' then
			vim.opt.clipboard = clipboard
		end
	end)
	-- Eager, so BufRead/FileType handlers see the argv buffers.
	load_rafi('rafi.config.autocmds')
	load_user('config.autocmds')
	require('rafi.pack').later(function()
		load_rafi('rafi.config.keymaps')
		-- Lets plugin/ files re-apply keys rafi.config.keymaps overrides;
		-- user keymaps load after, so they win over both.
		vim.api.nvim_exec_autocmds('User', { pattern = 'RafiKeymaps' })
		load_user('config.keymaps')
	end)
end

-- Extras and core-plugin state, stored in rafi.json:
-- { "extras": [ "lang.go", … ], "disabled": [ "editor.trouble", … ] }

---Extras enabled on a fresh install (no rafi.json and no lazyvim.json).
---@type string[]
M.defaults = {
	'coding.align',
	'coding.blink',
	'coding.mini-ai',
	'coding.mini-pairs',
	'coding.mini-splitjoin',
	'coding.mini-surround',
	'coding.mini-trailspace',
	'coding.ts-comments',
	'editor.dial',
	'editor.grug-far',
	'editor.guess-indent',
	'editor.leap',
	'editor.mini-hipatterns',
	'editor.namu',
	'editor.outline',
	'editor.undotree',
	'lang.docker',
	'lang.json',
	'lang.markdown',
	'lang.python',
	'lang.toml',
	'lang.typescript',
	'lang.yaml',
	'treesitter.nvim-treesitter',
	'ui.bookmarks',
	'ui.deadcolumn',
}

---Renamed extras: old name → new name.
---@type table<string, string>
M.aliases = {
	['lang.kubernetes'] = 'editor.kubectl',
}

---Core files the rest of the config calls into (e.g. the `Snacks` global in
---keymaps and lualine). Listing one in rafi.json `disabled` is ignored with
---a warning, since startup would break without it.
---@type string[]
M.required = { 'editor.snacks' }

---@class rafi.State
---@field extras string[]
---@field disabled string[]

---@type rafi.State?
M._cache = nil

---@return string
function M.json_path()
	return vim.g.rafi_json or (vim.fn.stdpath('config') .. '/rafi.json')
end

---@return rafi.State
local function default_state()
	return { extras = vim.deepcopy(M.defaults), disabled = {} }
end

---Migrate lazyvim.json to rafi.json extras list.
---@param path string
---@return string[]?
local function migrate_lazyvim(path)
	local ok_read, lines = pcall(vim.fn.readfile, path)
	if not ok_read or #lines == 0 then
		return
	end
	local ok, data = pcall(vim.json.decode, table.concat(lines, '\n'))
	if not ok or type(data) ~= 'table' then
		return
	end
	local extras = {}
	for _, mod in ipairs(data.extras or {}) do
		local name = mod
			:gsub('^rafi%.plugins%.extras%.', '')
			:gsub('^lazyvim%.plugins%.extras%.', '')
		name = M.aliases[name] or name
		if
			not vim.list_contains(extras, name)
			and require('rafi.extras').find(name)
		then
			table.insert(extras, name)
		end
	end
	return extras
end

---Return a rafi.json field if it's a list of strings, else warn and use
---`default`, so a bad hand edit can't make every guard call throw.
---@param value unknown
---@param field string
---@param default string[]
---@return string[]
local function valid_list(value, field, default)
	if value == nil then
		return vim.deepcopy(default)
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
	vim.notify(
		("rafi.json field '%s' must be a list of strings, using default: %s"):format(
			field,
			M.json_path()
		),
		vim.log.levels.WARN
	)
	return vim.deepcopy(default)
end

---Drop required core files (M.required) from the `disabled` list, warning
---for each one, so their guards never skip them.
---@param disabled string[]
---@return string[]
local function drop_required(disabled)
	return vim.tbl_filter(function(name)
		if not vim.list_contains(M.required, name) then
			return true
		end
		vim.notify(
			("'%s' is required and can't be disabled, ignoring it in rafi.json"):format(
				name
			),
			vim.log.levels.WARN
		)
		return false
	end, disabled)
end

---Read rafi.json once. Writes only when rafi.json is missing (migrated
---from lazyvim.json, or the defaults).
---@return rafi.State
function M.state()
	if M._cache then
		return M._cache
	end
	local path = M.json_path()
	local state = default_state()
	local ok_read, lines = pcall(vim.fn.readfile, path)
	if ok_read and #lines > 0 then
		local ok, data = pcall(vim.json.decode, table.concat(lines, '\n'))
		if ok and type(data) == 'table' then
			state.extras = valid_list(data.extras, 'extras', M.defaults)
			state.disabled = drop_required(valid_list(data.disabled, 'disabled', {}))
		else
			vim.notify(
				('rafi.json is malformed, using defaults: %s'):format(path),
				vim.log.levels.WARN
			)
		end
	end
	if not ok_read or #lines == 0 then
		local lazyvim_json = vim.g.rafi_lazyvim_json
			or (vim.fn.stdpath('config') .. '/lazyvim.json')
		state.extras = migrate_lazyvim(lazyvim_json) or state.extras
		M.save(state)
	end
	for i, name in ipairs(state.extras) do
		state.extras[i] = M.aliases[name] or name
	end
	M._cache = state
	return state
end

---@param state rafi.State
function M.save(state)
	local ok, json = pcall(vim.json.encode, state, { indent = '  ' })
	if not ok then
		json = vim.json.encode(state)
	end
	-- writefile can raise or return -1; either only warns, so state is
	-- still cached and guard calls don't retry the failing write.
	local ok_write, ret =
		pcall(vim.fn.writefile, vim.split(json, '\n'), M.json_path())
	local write_ok = ok_write and ret == 0
	if not write_ok then
		vim.notify(
			('Could not write rafi.json, changes will not persist: %s'):format(
				M.json_path()
			),
			vim.log.levels.WARN
		)
	end
	M._cache = state
end

---@param name string
---@return boolean
function M.enabled(name)
	return vim.list_contains(M.state().extras, name)
end

---@param name string Core plugin file as <cat>.<name>, e.g. 'editor.trouble'
---@return boolean
function M.disabled(name)
	return vim.list_contains(M.state().disabled, name)
end

---Enable or disable an extra and save rafi.json.
---@param name string
---@return boolean enabled
function M.toggle(name)
	local state = vim.deepcopy(M.state())
	local enabled = not vim.list_contains(state.extras, name)
	if enabled then
		table.insert(state.extras, name)
	else
		state.extras = vim.tbl_filter(function(n)
			return n ~= name
		end, state.extras)
	end
	M.save(state)
	return enabled
end

return M
