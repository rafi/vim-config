-- rafi.pack: command stubs (pack.command), build steps (pack.build) and
-- local checkouts (pack.dev). Runs in-process with fake commands and
-- loaders; pack.build uses mini.misc, which rafi.pack itself adds, as an
-- installed plugin.

local H = require('helpers')

local pack = require('rafi.pack')

-- Collects vim.notify messages, so errors can be asserted.
local notified ---@type string[]
local notify = vim.notify

-- Commands and augroups created by a case, removed after it.
local commands = {
	'RafiTestBroken',
	'RafiTestFwd',
	'RafiTestCount',
	'RafiTestComp',
	'RafiTestCompBroken',
}

local T = MiniTest.new_set({
	hooks = {
		pre_case = function()
			notified = {}
			vim.notify = function(msg)
				table.insert(notified, msg)
			end
			vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'a', 'b', 'c', 'd' })
		end,
		post_case = function()
			vim.notify = notify
			for _, name in ipairs(commands) do
				pcall(vim.api.nvim_del_user_command, name)
			end
			pcall(vim.api.nvim_del_augroup_by_name, 'rafi.pack.build.mini.misc')
		end,
	},
})

T['command()'] = MiniTest.new_set()

T['command()']['errors once when load() defines nothing'] = function()
	local calls = 0
	pack.command('RafiTestBroken', function()
		calls = calls + 1
	end)
	vim.cmd('RafiTestBroken x')
	H.eq(calls, 1)
	H.eq(#notified, 1)
	H.expect.no_equality(notified[1]:find(':RafiTestBroken', 1, true), nil)
end

T['command()']['re-runs with mods, range, bang and args'] = function()
	local got ---@type table
	pack.command('RafiTestFwd', function()
		vim.api.nvim_create_user_command('RafiTestFwd', function(a)
			got = {
				args = a.args,
				nfargs = #a.fargs,
				bang = a.bang,
				line1 = a.line1,
				line2 = a.line2,
				vertical = a.smods.vertical,
			}
		end, { nargs = '*', bang = true, range = true })
	end, { bang = true, range = true })
	vim.cmd([[vertical 2,3RafiTestFwd! { title = "a b" }]])
	H.eq(got, {
		args = '{ title = "a b" }',
		nfargs = 6,
		bang = true,
		line1 = 2,
		line2 = 3,
		vertical = true,
	})
end

T['command()']['re-runs with a count'] = function()
	local count ---@type integer
	pack.command('RafiTestCount', function()
		vim.api.nvim_create_user_command('RafiTestCount', function(a)
			count = a.count
		end, { count = true })
	end, { count = true })
	vim.cmd('3RafiTestCount')
	H.eq(count, 3)
end

T['command()']['completes lazily with the real command'] = function()
	pack.command('RafiTestComp', function()
		vim.api.nvim_create_user_command('RafiTestComp', function() end, {
			nargs = 1,
			complete = function()
				return { 'alpha', 'beta' }
			end,
		})
	end, { complete = true })
	H.eq(vim.fn.getcompletion('RafiTestComp ', 'cmdline'), { 'alpha', 'beta' })
end

T['command()']['broken lazy completion does not recurse'] = function()
	pack.command('RafiTestCompBroken', function() end, { complete = true })
	H.eq(vim.fn.getcompletion('RafiTestCompBroken ', 'cmdline'), {})
end

T['build()'] = MiniTest.new_set()

T['build()']['runs at registration when not built'] = function()
	local path = vim.pack.get({ 'mini.misc' }, { info = false })[1].path
	local built ---@type string?
	pack.build('mini.misc', {
		build = function(p)
			built = p
		end,
		is_built = function()
			return false
		end,
	})
	H.eq(built, path)
end

T['build()']['skips when built or not installed'] = function()
	local calls = 0
	local function build()
		calls = calls + 1
	end
	pack.build('mini.misc', {
		build = build,
		is_built = function()
			return true
		end,
	})
	pack.build('rafi-test-not-installed', {
		build = build,
		is_built = function()
			return false
		end,
	})
	pcall(
		vim.api.nvim_del_augroup_by_name,
		'rafi.pack.build.rafi-test-not-installed'
	)
	H.eq(calls, 0)
end

T['build()']['runs on its own PackChanged install/update only'] = function()
	local path = vim.pack.get({ 'mini.misc' }, { info = false })[1].path
	local calls = 0
	pack.build('mini.misc', {
		build = function()
			calls = calls + 1
		end,
	})
	local function fire(name, kind)
		vim.api.nvim_exec_autocmds('PackChanged', {
			data = { spec = { name = name }, kind = kind, path = path },
		})
	end
	fire('mini.misc', 'update')
	fire('mini.misc', 'delete')
	fire('other.nvim', 'install')
	H.eq(calls, 1)
end

T['dev()'] = MiniTest.new_set()

-- A dev/ checkout is loaded like :packadd loads a plugin: on 'runtimepath',
-- plugin/ files sourced (once, even when added twice) and help tags built.
T['dev()']['loads a checkout like packadd'] = function()
	local dir = vim.fn.stdpath('config') .. '/dev/rafi-test-dev.nvim'
	vim.fn.mkdir(dir .. '/plugin/sub', 'p')
	vim.fn.mkdir(dir .. '/doc', 'p')
	vim.fn.writefile({
		'vim.g.rafi_test_dev = (vim.g.rafi_test_dev or 0) + 1',
	}, dir .. '/plugin/sub/a.lua')
	vim.fn.writefile({ 'let g:rafi_test_dev_vim = 1' }, dir .. '/plugin/b.vim')
	vim.fn.writefile({ '*rafi-test-dev*' }, dir .. '/doc/rafi-test-dev.txt')
	local rtp = vim.o.rtp
	local ok, err = pcall(function()
		pack.dev('rafi-test-dev.nvim', 'https://example.invalid/never')
		pack.dev('rafi-test-dev.nvim', 'https://example.invalid/never')
		H.eq(vim.list_contains(vim.opt.rtp:get(), dir), true)
		H.eq(vim.g.rafi_test_dev, 1)
		H.eq(vim.g.rafi_test_dev_vim, 1)
		H.eq(vim.fn.filereadable(dir .. '/doc/tags'), 1)
	end)
	vim.o.rtp = rtp
	vim.g.rafi_test_dev, vim.g.rafi_test_dev_vim = nil, nil
	vim.fn.delete(dir, 'rf')
	assert(ok, err)
end

return T
