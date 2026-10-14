#!/usr/bin/env -S nvim -l
-- Test bootstrap: sandbox Neovim's stdpaths under .tests/, install
-- mini.test there with vim.pack, then run tests/**/*_spec.lua.
--
-- Usage: nvim -l tests/minit.lua --minitest [--offline] [spec files...]

local root = vim.uv.cwd()
local sandbox = root .. '/.tests'

local offline = vim.env.RAFI_OFFLINE == '1'
local files = {}
for _, a in ipairs(_G.arg) do
	if a == '--offline' then
		offline = true
	elseif a ~= '--minitest' then
		table.insert(files, a)
	end
end
_G.arg = files

-- Specs that need the network check this.
if offline then
	vim.env.RAFI_OFFLINE = '1'
end

-- Real dirs, read before the XDG variables below change stdpath().
local real = { vim.fn.stdpath('config'), vim.fn.stdpath('data') }

-- Point every stdpath at the sandbox. Child Neovims started by specs
-- inherit these, so they never touch the real config, data or state.
for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
	vim.env[('XDG_%s_HOME'):format(name:upper())] = sandbox .. '/' .. name
end
local config_dir = sandbox .. '/config/nvim'

---Build the sandbox config dir: symlinks to the repo's tracked runtime
---files, so edits are tested live. lua/config/ (untracked user
---overrides) is left out on purpose, and so are dev/ checkouts, except
---the unpublished plugins core files load with rafi.pack.dev(): without
---their checkout the sandbox would try to clone a missing repo.
local function link_config()
	vim.fn.mkdir(config_dir .. '/lua', 'p')
	vim.fn.mkdir(config_dir .. '/dev', 'p')
	local links = { 'init.lua', 'after', 'plugin', 'snippets', 'lua/rafi' }
	for _, name in ipairs({
		'packcount.nvim',
		'packman.nvim',
		'theme-loader.nvim',
	}) do
		if vim.uv.fs_stat(root .. '/dev/' .. name) then
			table.insert(links, 'dev/' .. name)
		end
	end
	for _, rel in ipairs(links) do
		local dst = config_dir .. '/' .. rel
		if not vim.uv.fs_lstat(dst) then
			assert(vim.uv.fs_symlink(root .. '/' .. rel, dst))
		end
	end
end

---@param path string
---@return table?
local function read_json(path)
	local ok, lines = pcall(vim.fn.readfile, path)
	if ok and #lines > 0 then
		return vim.json.decode(table.concat(lines, '\n'))
	end
end

---@param path string
---@param data table
local function write_json(path, data)
	vim.fn.writefile(
		vim.split(vim.json.encode(data, { indent = '  ' }), '\n'),
		path
	)
end

---Copy the repo lockfile into the sandbox, keeping sandbox-only entries
---(mini.test). vim.pack writes to its lockfile, so the repo's copy must
---never be the one in use. Returns plugins whose locked revision changed
---since the last run, which need a checkout to the new revision.
---@return string[]
local function sync_lockfile()
	local lock_path = config_dir .. '/nvim-pack-lock.json'
	local repo = read_json(root .. '/nvim-pack-lock.json') or { plugins = {} }
	local lock = read_json(lock_path) or { plugins = {} }
	local changed = {}
	for name, data in pairs(repo.plugins) do
		local old = lock.plugins[name]
		if old and old.rev ~= data.rev then
			table.insert(changed, name)
		end
		lock.plugins[name] = data
	end
	write_json(lock_path, lock)
	if vim.fn.exists('+packlockfile') == 1 then
		vim.o.packlockfile = lock_path
	end
	return changed
end

link_config()

local changed = sync_lockfile()

-- Former core plugins (now extras) plus two default extras: other extras
-- install tree-sitter parsers and mason tools on `later`, which is slow
-- and needs network. coding.blink and editor.leap install neither.
write_json(config_dir .. '/rafi.json', {
	extras = {
		'coding.blink',
		'coding.lazydev',
		'colorscheme.tokyonight',
		'editor.auto-session',
		'editor.leap',
		'editor.packman',
		'editor.tmux-navigator',
		'editor.todo-comments',
		'editor.trouble',
		'editor.window-picker',
		'git.committia',
		'git.diffview',
		'git.gitsigns',
		'git.neogit',
		'treesitter.autotag',
		'treesitter.matchup',
		'treesitter.textobjects',
		'ui.bufferline',
		'ui.packcount',
		'ui.which-key',
	},
	disabled = { 'mason' },
})

---Replace the real config and data dirs in a path option (runtimepath,
---packpath) with the repo and the sandbox's site dir.
---@param option string
local function sandbox_paths(option)
	local paths = vim.tbl_filter(function(p)
		return not vim.startswith(p, real[1]) and not vim.startswith(p, real[2])
	end, vim.opt[option]:get())
	table.insert(paths, 1, root)
	table.insert(paths, 2, vim.fn.stdpath('data') .. '/site')
	vim.opt[option] = paths
end
sandbox_paths('runtimepath')
sandbox_paths('packpath')
package.path = ('%s;%s/tests/?.lua'):format(package.path, root)

-- The first vim.pack.add() also installs every lockfile plugin that is
-- missing, so child Neovims start with the whole config available.
vim.pack.add({ 'https://github.com/nvim-mini/mini.test' }, { confirm = false })
if #changed > 0 and not offline then
	vim.pack.update(changed, { force = true, target = 'lockfile' })
end

-- Warm-up start of the full config, so plugins it adds that are not in
-- the lockfile (dev/ checkouts use rafi.pack.dev) install here once,
-- instead of racing a spec's startup.
local warmup = vim.system({ vim.v.progpath, '--headless', '+qa!' }):wait()
if warmup.code ~= 0 then
	io.stderr:write('Config warm-up failed:\n' .. warmup.stderr .. '\n')
end

require('mini.test').setup({
	collect = {
		find_files = function()
			return #_G.arg > 0 and _G.arg
				or vim.fn.globpath('tests', '**/*_spec.lua', true, true)
		end,
	},
})
MiniTest.run()
