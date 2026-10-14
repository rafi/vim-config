-- Fresh install: the config starts with empty data dirs and no lockfile, so
-- vim.pack clones each plugin while startup runs (like `make docker-local`).
-- Needs network, so it is skipped with --offline or RAFI_OFFLINE=1.

local H = require('helpers')

local tmp ---@type string

local T = MiniTest.new_set({
	hooks = {
		pre_case = function()
			if vim.env.RAFI_OFFLINE == '1' then
				MiniTest.skip('needs network')
			end
			tmp = vim.fn.tempname()
			vim.fn.mkdir(tmp .. '/config/nvim/lua', 'p')
		end,
		post_case = function()
			if tmp then
				vim.fn.delete(tmp, 'rf')
			end
		end,
	},
})

-- Runs in the child before init.lua. After VimEnter it queues a `later`
-- marker, so it runs after the config's own `later` callbacks. Once the
-- marker ran (or after 200s) it prints one JSON line and quits.
local child_setup = [[lua
	local timer = vim.uv.new_timer()
	local started = vim.uv.now()
	vim.api.nvim_create_autocmd('VimEnter', {
		once = true,
		callback = function()
			vim.schedule(function()
				require('rafi.pack').later(function() vim.g.rafi_test_later = true end)
			end)
			timer:start(200, 200, vim.schedule_wrap(function()
				local timed_out = vim.uv.now() - started > 200000
				if not (vim.g.rafi_test_later or timed_out) then return end
				timer:stop()
				io.stdout:write(vim.json.encode({
					drained = vim.g.rafi_test_later == true,
					messages = vim.api.nvim_exec2('messages', { output = true }).output,
					keymap = vim.fn.maparg('<leader>w', 'n'),
					mason_update = vim.fn.exists(':MasonUpdate'),
				}) .. '\n')
				vim.cmd('qa!')
			end))
		end,
	})
]]

-- A config dir with the repo's runtime files, no `lua/config/`, no `dev/`
-- and no lockfile, with data, state and cache dirs that start empty.
local function link_config()
	local dir = tmp .. '/config/nvim'
	for _, rel in ipairs({ 'init.lua', 'after', 'plugin', 'lua/rafi' }) do
		assert(vim.uv.fs_symlink(H.root .. '/' .. rel, dir .. '/' .. rel))
	end
	-- Core plugins only: extras install parsers and tools, which is slow.
	vim.fn.writefile({ '{"extras":[]}' }, dir .. '/rafi.json')
end

-- vim.pack.add() waits on the event loop while it clones a plugin. That
-- must not run `later` callbacks (keymaps need Snacks, set up by a plugin/
-- file sourced after the one that is installing), nor mason's PackChanged
-- build hook before mason's setup defined `:MasonUpdate`.
T['starts without errors'] = function()
	link_config()
	local res = vim
		.system({
			vim.v.progpath,
			'--headless',
			'--cmd',
			(child_setup:gsub('\n', ' ')),
		}, {
			env = {
				XDG_CONFIG_HOME = tmp .. '/config',
				XDG_DATA_HOME = tmp .. '/data',
				XDG_STATE_HOME = tmp .. '/state',
				XDG_CACHE_HOME = tmp .. '/cache',
			},
			text = true,
			timeout = 240000,
		})
		:wait(250000)
	local lines = vim.split(vim.trim(res.stdout or ''), '\n')
	local ok, out = pcall(vim.json.decode, lines[#lines])
	assert(
		ok,
		'no report from the child:\n' .. (res.stdout or '') .. (res.stderr or '')
	)

	H.eq(out.drained, true)
	-- Install progress is expected, errors are not.
	local errors = vim.tbl_filter(function(line)
		return line:find('Error', 1, true) or line:find('E%d%d+:') ~= nil
	end, vim.split(out.messages, '\n'))
	H.eq(errors, {})
	H.eq(out.keymap, '<Cmd>write<CR>')
	H.eq(out.mason_update, 2)
end

return T
