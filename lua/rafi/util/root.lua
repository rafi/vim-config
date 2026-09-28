-- Project root detection
-- https://github.com/rafi/vim-config
--
-- Resolves `vim.g.root_spec` (default: lsp, .git/lua markers, cwd), cached
-- per buffer and cleared on LspAttach, BufWritePost, DirChanged, BufEnter.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/root.lua

---@class rafi.util.root
---@overload fun(opts?: {normalize?: boolean, buf?: number}): string
local M = setmetatable({}, {
	__call = function(m, ...)
		return m.get(...)
	end,
})

---@alias rafi.RootFn fun(buf: number): (string|string[])
---@alias rafi.RootSpec string|string[]|rafi.RootFn

---@type rafi.RootSpec[]
M.spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

---@type table<number, string>
M.cache = {}

vim.api.nvim_create_autocmd(
	{ 'LspAttach', 'BufWritePost', 'DirChanged', 'BufEnter' },
	{
		group = vim.api.nvim_create_augroup('rafi.root_cache', { clear = true }),
		callback = function(event)
			M.cache[event.buf] = nil
		end,
	}
)

---@param path string
---@return string
local function norm(path)
	return vim.fs.normalize(path)
end

---@param path? string
---@return string?
function M.realpath(path)
	if path == '' or path == nil then
		return nil
	end
	path = vim.fn.has('win32') == 0 and vim.uv.fs_realpath(path) or path
	return norm(path)
end

---@param buf number
function M.bufpath(buf)
	return M.realpath(vim.api.nvim_buf_get_name(assert(buf)))
end

M.detectors = {}

function M.detectors.cwd()
	return { vim.uv.cwd() }
end

function M.detectors.lsp(buf)
	local bufpath = M.bufpath(buf)
	if not bufpath then
		return {}
	end
	local roots = {} ---@type string[]
	local clients = vim.lsp.get_clients({ bufnr = buf })
	for _, client in pairs(clients) do
		if not vim.tbl_contains(vim.g.root_lsp_ignore or {}, client.name) then
			for _, ws in pairs(client.config.workspace_folders or {}) do
				roots[#roots + 1] = vim.uri_to_fname(ws.uri)
			end
			if client.root_dir then
				roots[#roots + 1] = client.root_dir
			end
		end
	end
	return vim.tbl_filter(function(path)
		path = norm(path)
		return path and bufpath:find(path, 1, true) == 1
	end, roots)
end

---@param patterns string[]|string
function M.detectors.pattern(buf, patterns)
	patterns = type(patterns) == 'string' and { patterns } or patterns
	local path = M.bufpath(buf) or vim.uv.cwd()
	local pattern = vim.fs.find(function(name)
		for _, p in ipairs(patterns) do
			if name == p then
				return true
			end
			if p:sub(1, 1) == '*' and name:find(vim.pesc(p:sub(2)) .. '$') then
				return true
			end
		end
		return false
	end, { path = path, upward = true })[1]
	return pattern and { vim.fs.dirname(pattern) } or {}
end

---@param spec rafi.RootSpec
---@return rafi.RootFn
function M.resolve(spec)
	if M.detectors[spec] then
		return M.detectors[spec]
	elseif type(spec) == 'function' then
		return spec
	end
	return function(buf)
		return M.detectors.pattern(buf, spec)
	end
end

---@param opts? { buf?: number, spec?: rafi.RootSpec[], all?: boolean }
---@return { spec: rafi.RootSpec, paths: string[] }[]
function M.detect(opts)
	opts = opts or {}
	opts.spec = opts.spec
		or type(vim.g.root_spec) == 'table' and vim.g.root_spec
		or M.spec
	opts.buf = (opts.buf == nil or opts.buf == 0)
			and vim.api.nvim_get_current_buf()
		or opts.buf

	local ret = {}
	for _, spec in ipairs(opts.spec) do
		local paths = M.resolve(spec)(opts.buf) or {}
		paths = type(paths) == 'table' and paths or { paths }
		local roots = {} ---@type string[]
		for _, p in ipairs(paths) do
			local pp = M.realpath(p)
			if pp and not vim.tbl_contains(roots, pp) then
				roots[#roots + 1] = pp
			end
		end
		table.sort(roots, function(a, b)
			return #a > #b
		end)
		if #roots > 0 then
			ret[#ret + 1] = { spec = spec, paths = roots }
			if opts.all == false then
				break
			end
		end
	end
	return ret
end

-- Returns the root directory of a buffer (default: current).
---@param opts? {normalize?: boolean, buf?: number}
---@return string
function M.get(opts)
	opts = opts or {}
	local buf = opts.buf or vim.api.nvim_get_current_buf()
	local ret = M.cache[buf]
	if not ret then
		local roots = M.detect({ all = false, buf = buf })
		ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
		M.cache[buf] = ret
	end
	if opts.normalize or vim.fn.has('win32') == 0 then
		return ret
	end
	return (ret:gsub('/', '\\'))
end

-- Notifies every root detected for the current buffer, one line per path
-- with the spec that found it.
-- The checked one is what get() returns.
---@return string
function M.info()
	local spec = type(vim.g.root_spec) == 'table' and vim.g.root_spec or M.spec
	local roots = M.detect({ all = true })
	local lines = {} ---@type string[]
	local first = true
	for _, root in ipairs(roots) do
		local name = root.spec
		if type(name) == 'table' then
			name = table.concat(name, ', ')
		elseif type(name) == 'function' then
			name = 'function'
		end
		for _, path in ipairs(root.paths) do
			lines[#lines + 1] = ('- [%s] `%s` **(%s)**'):format(
				first and 'x' or ' ',
				path,
				name
			)
			first = false
		end
	end
	lines[#lines + 1] = '```lua'
	lines[#lines + 1] = 'vim.g.root_spec = ' .. vim.inspect(spec)
	lines[#lines + 1] = '```'
	vim.notify(
		table.concat(lines, '\n'),
		vim.log.levels.INFO,
		{ title = 'Roots' }
	)
	return roots[1] and roots[1].paths[1] or vim.uv.cwd()
end

-- Returns the git root of the current root, or the root itself.
---@return string
function M.git()
	local root = M.get()
	local git_root = vim.fs.find('.git', { path = root, upward = true })[1]
	return git_root and vim.fn.fnamemodify(git_root, ':h') or root
end

return M
