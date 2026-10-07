-- rafi.extras loader and :RafiExtras items, against fake extras in a temp
-- dir (vim.g.rafi_extras_dirs). No real extra is loaded.

local H = require('helpers')

local config = require('rafi.config')
local extras = require('rafi.extras')

local tmp ---@type string

-- Collects vim.notify messages, so warnings can be asserted.
local notified ---@type string[]
local notify = vim.notify

---@param name string <cat>.<name>
---@param lines string[]
local function write_extra(name, lines)
	local cat, file = name:match('^([^.]+)%.(.+)$')
	vim.fn.mkdir(tmp .. '/' .. cat, 'p')
	vim.fn.writefile(lines, ('%s/%s/%s.lua'):format(tmp, cat, file))
end

local T = MiniTest.new_set({
	hooks = {
		pre_case = function()
			tmp = vim.fn.tempname()
			vim.g.rafi_extras_dirs = { tmp }
			vim.g.rafi_json = tmp .. '/rafi.json'
			vim.g.rafi_test_order = {}
			config._cache = nil
			write_extra('demo.a', {
				'-- Demo extra A',
				"vim.g.rafi_test_order = vim.list_extend(vim.g.rafi_test_order, { 'a' })",
			})
			write_extra('demo.b', { '-- Demo extra B (broken)', "error('boom')" })
			write_extra('demo.c', {
				'-- Demo extra C',
				"vim.g.rafi_test_order = vim.list_extend(vim.g.rafi_test_order, { 'c' })",
			})
			notified = {}
			vim.notify = function(msg)
				table.insert(notified, msg)
			end
		end,
		post_case = function()
			vim.notify = notify
			vim.g.rafi_extras_dirs = nil
			vim.g.rafi_json = nil
			vim.g.rafi_test_order = nil
			config._cache = nil
			vim.fn.delete(tmp, 'rf')
		end,
	},
})

T['available() lists extras with descriptions'] = function()
	local names = vim.tbl_map(function(e)
		return e.name .. ': ' .. e.desc
	end, extras.available())
	H.eq(names, {
		'demo.a: Demo extra A',
		'demo.b: Demo extra B (broken)',
		'demo.c: Demo extra C',
	})
end

T['load() sources in order and survives failures'] = function()
	config._cache = {
		extras = { 'demo.c', 'demo.missing', 'demo.b', 'demo.a' },
		disabled = {},
	}
	extras.load()
	H.eq(vim.g.rafi_test_order, { 'c', 'a' })
	local joined = table.concat(notified, '\n')
	H.expect.no_equality(joined:find('demo.missing', 1, true), nil)
	H.expect.no_equality(joined:find('demo.b', 1, true), nil)
end

-- Leftovers from the lazy.nvim version: a returned spec table and a call
-- to the removed LazyVim global both warn instead of passing silently.
T['source() flags lazy.nvim leftovers'] = function()
	write_extra('demo.spec', { "return { 'foo/bar', opts = {} }" })
	write_extra('demo.lazyvim', { 'LazyVim.root()' })
	H.eq(extras.source(extras.find('demo.spec'), 'demo.spec'), true)
	H.eq(extras.source(extras.find('demo.lazyvim'), 'demo.lazyvim'), false)
	H.eq(#notified, 2)
	H.expect.no_equality(notified[1]:find('lazy.nvim spec', 1, true), nil)
	H.expect.no_equality(notified[2]:find('rafi.util.root', 1, true), nil)
end

T['items() reflects toggle()'] = function()
	vim.fn.writefile({ vim.json.encode({ extras = {} }) }, vim.g.rafi_json)
	local function enabled()
		local ret = {}
		for _, item in ipairs(extras.items()) do
			ret[item.name] = item.enabled
		end
		return ret
	end
	H.eq(
		enabled(),
		{ ['demo.a'] = false, ['demo.b'] = false, ['demo.c'] = false }
	)
	config.toggle('demo.a')
	H.eq(enabled(), { ['demo.a'] = true, ['demo.b'] = false, ['demo.c'] = false })
end

return T
