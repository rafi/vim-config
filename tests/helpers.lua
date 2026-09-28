-- Shared test helpers
-- https://github.com/rafi/vim-config

local M = {}

M.expect = MiniTest.expect
M.eq = MiniTest.expect.equality

-- Repo root, specs run from it (see tests/minit.lua).
M.root = vim.uv.cwd()

-- Runs in the child before init.lua via --cmd: mini.test always passes
-- `--clean`, which drops the config and data dirs from 'runtimepath' and
-- 'packpath', so they are put back. On VimEnter every plugin/ file has
-- queued its `rafi.pack.later` callbacks, so one queued then runs last
-- and flags that the queue drained.
local child_setup = [[lua
	local config = vim.fn.stdpath('config')
	vim.opt.rtp:prepend(config)
	vim.opt.rtp:append(config .. '/after')
	vim.opt.packpath:prepend(vim.fn.stdpath('data') .. '/site')
	vim.api.nvim_create_autocmd('VimEnter', {
		once = true,
		callback = function()
			require('rafi.pack').later(function() vim.g.rafi_test_later = true end)
		end,
	})
]]

---Start `child` with the full config from the sandbox dir built by
---tests/minit.lua, and wait until its `later` callbacks ran.
---@param child MiniTest.child
function M.start_config(child)
	local init = vim.fn.stdpath('config') .. '/init.lua'
	child.start({ '--cmd', (child_setup:gsub('\n', ' ')), '-u', init })
	local ok = child.lua([[
		return vim.wait(5000, function() return vim.g.rafi_test_later end, 20)
	]])
	assert(ok, 'rafi.pack.later callbacks did not run within 5s')
end

---Lua modules from `mods` not yet loaded in the child.
---@param child MiniTest.child
---@param mods string[]
---@return string[]
function M.not_loaded(child, mods)
	return child.lua(
		[[
		return vim.tbl_filter(function(mod)
			return package.loaded[mod] == nil
		end, ...)
	]],
		{ mods }
	)
end

---Files matching any of the globs under the repo root, relative to it.
---@param ... string
---@return string[]
function M.glob(...)
	local ret = {}
	for _, pattern in ipairs({ ... }) do
		for _, path in ipairs(vim.fn.globpath(M.root, pattern, false, true)) do
			table.insert(ret, path:sub(#M.root + 2))
		end
	end
	return ret
end

return M
