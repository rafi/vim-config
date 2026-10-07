-- rafi.config: rafi.json state, defaults, aliases and lazyvim.json
-- migration. Runs in-process against temp files via vim.g overrides.

local H = require('helpers')

local config = require('rafi.config')

local tmp ---@type string

---@param path string
---@param data table
local function write_json(path, data)
	vim.fn.writefile({ vim.json.encode(data) }, path)
end

---@param path string
---@return table
local function read_json(path)
	return vim.json.decode(table.concat(vim.fn.readfile(path), '\n'))
end

-- Collects vim.notify messages, so warnings can be asserted.
local notified ---@type string[]
local notify = vim.notify

local T = MiniTest.new_set({
	hooks = {
		pre_case = function()
			tmp = vim.fn.tempname()
			vim.fn.mkdir(tmp, 'p')
			vim.g.rafi_json = tmp .. '/rafi.json'
			vim.g.rafi_lazyvim_json = tmp .. '/lazyvim.json'
			config._cache = nil
			notified = {}
			vim.notify = function(msg)
				table.insert(notified, msg)
			end
		end,
		post_case = function()
			vim.notify = notify
			vim.g.rafi_json = nil
			vim.g.rafi_lazyvim_json = nil
			config._cache = nil
			vim.fn.delete(tmp, 'rf')
		end,
	},
})

T['state()'] = MiniTest.new_set()

T['state()']['writes defaults when rafi.json is missing'] = function()
	local state = config.state()
	H.eq(state.extras, config.defaults)
	H.eq(state.disabled, {})
	H.eq(read_json(vim.g.rafi_json).extras, config.defaults)
end

T['state()']['reads extras and disabled'] = function()
	write_json(vim.g.rafi_json, { extras = { 'lang.go' }, disabled = { 'lint' } })
	H.eq(config.enabled('lang.go'), true)
	H.eq(config.enabled('lang.python'), false)
	H.eq(config.disabled('lint'), true)
	H.eq(config.disabled('conform'), false)
end

T['state()']['resolves renamed extras'] = function()
	write_json(vim.g.rafi_json, { extras = { 'lang.kubernetes' } })
	H.eq(config.state().extras, { 'editor.kubectl' })
end

T['state()']['falls back on a bad field'] = function()
	write_json(vim.g.rafi_json, { extras = 'lang.go', disabled = { 1 } })
	local state = config.state()
	H.eq(state.extras, config.defaults)
	H.eq(state.disabled, {})
	H.eq(#notified, 2)
end

T['state()']['ignores required core files in disabled'] = function()
	write_json(vim.g.rafi_json, { extras = {}, disabled = { 'snacks', 'lint' } })
	H.eq(config.state().disabled, { 'lint' })
	H.eq(config.disabled('snacks'), false)
	H.eq(#notified, 1)
	H.expect.no_equality(notified[1]:find('snacks', 1, true), nil)
end

T['state()']['falls back on malformed json'] = function()
	vim.fn.writefile({ '{ nope' }, vim.g.rafi_json)
	H.eq(config.state().extras, config.defaults)
	H.eq(#notified, 1)
	-- Left on disk for the user to fix, not replaced by defaults.
	H.eq(vim.fn.readfile(vim.g.rafi_json), { '{ nope' })
end

T['state()']['migrates lazyvim.json'] = function()
	write_json(vim.g.rafi_lazyvim_json, {
		extras = {
			'rafi.plugins.extras.lang.go',
			'lazyvim.plugins.extras.lang.kubernetes',
			'lazyvim.plugins.extras.lang.does-not-exist',
			'plugins.extras.lang.toml',
			'lazyvim.plugins.extras.lang.go',
		},
	})
	local want = { 'lang.go', 'editor.kubectl', 'lang.toml' }
	H.eq(config.state().extras, want)
	H.eq(read_json(vim.g.rafi_json).extras, want)
	-- Unmatched names are reported once, by their original module name.
	H.eq(#notified, 1)
	H.expect.no_equality(
		notified[1]:find('lazyvim.plugins.extras.lang.does-not-exist', 1, true),
		nil
	)
end

T['toggle()'] = function()
	write_json(vim.g.rafi_json, { extras = {} })
	H.eq(config.toggle('lang.go'), true)
	H.eq(read_json(vim.g.rafi_json).extras, { 'lang.go' })
	H.eq(config.toggle('lang.go'), false)
	H.eq(read_json(vim.g.rafi_json).extras, {})
end

-- theme-loader.nvim writes `colorscheme` into rafi.json after the state is
-- cached; a later toggle must not drop it.
T['toggle() keeps keys written to rafi.json since startup'] = function()
	write_json(vim.g.rafi_json, { extras = {} })
	config.state()
	write_json(vim.g.rafi_json, { extras = {}, colorscheme = 'desert' })
	config.toggle('lang.go')
	local data = read_json(vim.g.rafi_json)
	H.eq(data.extras, { 'lang.go' })
	H.eq(data.colorscheme, 'desert')
end

-- An unwritable rafi.json only warns: the state is still cached, so
-- every later guard call doesn't retry (and fail) the same write.
T['toggle() survives an unwritable rafi.json'] = function()
	vim.g.rafi_json = '/dev/null/unwritable/rafi.json'
	H.eq(config.toggle('lang.go'), true)
	H.expect.no_equality(config._cache, nil)
	H.expect.no_equality(
		table.concat(notified, '\n'):find('rafi.json', 1, true),
		nil
	)
	H.eq(config.enabled('lang.go'), true)
end

T['defaults and aliases name existing extras'] = function()
	local extras = require('rafi.extras')
	for _, name in ipairs(config.defaults) do
		H.expect.no_equality(extras.find(name), nil)
	end
	for _, name in pairs(config.aliases) do
		H.expect.no_equality(extras.find(name), nil)
	end
end

return T
