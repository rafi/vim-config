-- Picker helpers. Uses snacks.picker unless an extra registers another.
-- https://github.com/rafi/vim-config
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/pick.lua

---@class rafi.util.pick.Opts: snacks.picker.Config
---@field root? boolean Search from the project root (default: true)
---@field buf? number Buffer to detect the root from

---@class rafi.util.pick
---@overload fun(command?: string, opts?: rafi.util.pick.Opts): fun()
local M = setmetatable({}, {
	__call = function(m, ...)
		return m.wrap(...)
	end,
})

-- Generic picker command names to snacks sources.
M.commands = {
	files = 'files',
	live_grep = 'grep',
	oldfiles = 'recent',
}

---@class rafi.util.pick.Picker
---@field name string
---@field commands table<string, string> Generic command names → picker's own
---@field open fun(command: string, opts: rafi.util.pick.Opts)

-- Picker registered by an extra (e.g. editor.telescope), replacing snacks.
---@type rafi.util.pick.Picker?
M.picker = nil

-- Makes `picker` the one every `rafi.util.pick` call opens.
-- The last extra to register wins.
---@param picker rafi.util.pick.Picker
function M.register(picker)
	M.picker = picker
end

-- Opens the registered picker (snacks by default), from the project root
-- unless `root = false`.
---@param command? string
---@param opts? rafi.util.pick.Opts
function M.open(command, opts)
	command = command and command ~= 'auto' and command or 'files'
	opts = vim.deepcopy(opts or {})
	if not opts.cwd and opts.root ~= false then
		opts.cwd = require('rafi.util.root')({ buf = opts.buf })
	end
	if M.picker then
		M.picker.open(M.picker.commands[command] or command, opts)
		return
	end
	Snacks.picker.pick(M.commands[command] or command, opts)
end

-- Returns a function that opens the picker, for keymaps.
---@param command? string
---@param opts? rafi.util.pick.Opts
---@return fun()
function M.wrap(command, opts)
	return function()
		M.open(command, opts)
	end
end

---@return fun()
function M.config_files()
	return M.wrap('files', { cwd = vim.fn.stdpath('config') })
end

return M
