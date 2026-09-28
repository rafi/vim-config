-- rafi.health: :checkhealth rafi reports on rafi.json without crashing.
-- Runs in-process with vim.health stubbed to record each report.

local H = require('helpers')

local config = require('rafi.config')

local tmp ---@type string

-- Reports as { level, message } pairs, e.g. { 'error', '...' }.
local reports ---@type string[][]
local health = vim.health

---@param data table
local function write_json(data)
	vim.fn.writefile({ vim.json.encode(data) }, vim.g.rafi_json)
end

---@param level string
---@return string[]
local function messages(level)
	local ret = {}
	for _, r in ipairs(reports) do
		if r[1] == level then
			table.insert(ret, r[2])
		end
	end
	return ret
end

---@param level string
---@param text string
---@return boolean
local function reported(level, text)
	for _, msg in ipairs(messages(level)) do
		if msg:find(text, 1, true) then
			return true
		end
	end
	return false
end

local T = MiniTest.new_set({
	hooks = {
		pre_case = function()
			tmp = vim.fn.tempname()
			vim.fn.mkdir(tmp, 'p')
			vim.g.rafi_json = tmp .. '/rafi.json'
			config._cache = nil
			reports = {}
			local stub = {}
			for _, level in ipairs({ 'start', 'ok', 'info', 'warn', 'error' }) do
				stub[level] = function(msg)
					table.insert(reports, { level, msg })
				end
			end
			vim.health = stub
		end,
		post_case = function()
			vim.health = health
			vim.g.rafi_json = nil
			config._cache = nil
			vim.fn.delete(tmp, 'rf')
		end,
	},
})

T['reports a valid rafi.json'] = function()
	write_json({ extras = { 'lang.go' }, disabled = {} })
	require('rafi.health').check()
	H.eq(messages('error'), {})
	H.eq(reported('ok', 'All extras in `rafi.json` exist'), true)
end

T['reports bad field types instead of crashing'] = function()
	write_json({ extras = 'lang.go', disabled = { 1, 'lint' } })
	require('rafi.health').check()
	H.eq(reported('error', 'field `extras` must be a list of strings'), true)
	H.eq(reported('error', 'field `disabled` must be a list of strings'), true)
	H.eq(reported('ok', 'All extras'), false)
end

T['warns about unknown extras and required disabled'] = function()
	write_json({
		extras = { 'lang.does-not-exist' },
		disabled = { 'snacks' },
	})
	require('rafi.health').check()
	H.eq(reported('warn', 'lang.does-not-exist'), true)
	H.eq(reported('warn', '`snacks` is required'), true)
end

return T
