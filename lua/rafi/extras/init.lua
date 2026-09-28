-- Rafi extras: opt-in vim.pack plugin files, enabled in rafi.json
-- https://github.com/rafi/vim-config

local M = {}

---@return string[]
function M.dirs()
	local config_dir = vim.fn.stdpath('config')
	return vim.g.rafi_extras_dirs
		or { config_dir .. '/lua/rafi/extras', config_dir .. '/lua/plugins/extras' }
end

---@class rafi.Extra
---@field name string Pattern: <category>.<name>
---@field desc string
---@field path string

---@return rafi.Extra[]
function M.available()
	local ret, seen = {}, {}
	for _, dir in ipairs(M.dirs()) do
		for _, path in ipairs(vim.fn.glob(dir .. '/*/*.lua', false, true)) do
			local cat, file = path:match('([^/]+)/([^/]+)%.lua$')
			local name = cat .. '.' .. file
			if not seen[name] then
				seen[name] = true
				local first = vim.fn.readfile(path, '', 1)[1] or ''
				local desc = first:gsub('^%-%-+%s*', '')
				table.insert(ret, { name = name, desc = desc, path = path })
			end
		end
	end
	table.sort(ret, function(a, b)
		return a.name < b.name
	end)
	return ret
end

---@param name string
---@return string?
function M.find(name)
	local cat, file = name:match('^([^.]+)%.(.+)$')
	if not cat then
		return
	end
	for _, dir in ipairs(M.dirs()) do
		local path = ('%s/%s/%s.lua'):format(dir, cat, file)
		if vim.uv.fs_stat(path) then
			return path
		end
	end
end

---@param path string
---@param label string
---@return boolean
function M.source(path, label)
	local chunk, err = loadfile(path)
	local ok = chunk ~= nil
	if chunk then
		ok, err = pcall(chunk)
	end
	if not ok then
		vim.notify(
			('Failed loading %s: %s'):format(label, err),
			vim.log.levels.WARN
		)
	end
	return ok
end

---Source enabled extras (rafi.json order), then user lua/plugins/*.lua.
function M.load()
	local unknown = {}
	for _, name in ipairs(require('rafi.config').state().extras) do
		local path = M.find(name)
		if path then
			M.source(path, name)
		else
			table.insert(unknown, name)
		end
	end
	if #unknown > 0 then
		vim.notify(
			'Unknown extras in rafi.json: ' .. table.concat(unknown, ', '),
			vim.log.levels.WARN
		)
	end
	local user = vim.fn.stdpath('config') .. '/lua/plugins'
	local files = vim.fn.glob(user .. '/*.lua', false, true)
	table.sort(files)
	for _, path in ipairs(files) do
		M.source(path, 'lua/plugins/' .. vim.fs.basename(path))
	end
end

---@return table[]
function M.items()
	local config = require('rafi.config')
	return vim.tbl_map(function(extra)
		return {
			text = extra.name .. ' ' .. extra.desc,
			name = extra.name,
			desc = extra.desc,
			file = extra.path,
			enabled = config.enabled(extra.name),
		}
	end, M.available())
end

---Picker to toggle extras; changes apply after a restart.
function M.show()
	Snacks.picker({
		title = 'Rafi Extras',
		focus = 'list',
		layout = {
			hidden = { 'input' },
			layout = {
				box = 'vertical',
				width = 0.8,
				min_width = 80,
				height = 0.85,
				{
					box = 'vertical',
					border = true,
					title = '{title} {live} {flags}',
					footer = {
						{ ' <CR> ', 'SnacksFooterKey' },
						{ ' toggle extra (applies after restart) ', 'SnacksFooterDesc' },
					},
					footer_pos = 'center',
					{ win = 'input', height = 1, border = 'bottom' },
					{ win = 'list', border = 'none' },
				},
				{ win = 'preview', title = '{preview}', border = true, height = 0.5 },
			},
		},
		items = M.items(),
		preview = 'file',
		format = function(item)
			return {
				{
					item.enabled and '● ' or '○ ',
					item.enabled and 'DiagnosticOk' or 'Comment',
				},
				{ ('%-28s'):format(item.name), 'Identifier' },
				{ item.desc, 'Comment' },
			}
		end,
		confirm = function(picker, item)
			local enabled = require('rafi.config').toggle(item.name)
			vim.notify(
				('%s %s - restart Neovim to apply'):format(
					enabled and 'Enabled' or 'Disabled',
					item.name
				)
			)
			picker:close()
			vim.schedule(M.show)
		end,
	})
end

return M
