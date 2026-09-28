-- Lazy-loading helpers for vim.pack plugin files under plugin/
-- https://github.com/rafi/vim-config
--
-- Thin wrappers around MiniMisc.safely(), so every plugin/ file can
-- `local pack = require('rafi.pack')` regardless of sourcing order.

vim.pack.add({ 'https://github.com/nvim-mini/mini.misc' })
local misc = require('mini.misc')

local M = {}

---Run now, errors become warnings.
---@param f fun()
function M.now(f)
	misc.safely('now', f)
end

---Run after startup (after the next "now" call).
---@param f fun()
function M.later(f)
	misc.safely('later', f)
end

---Run once on first event, e.g. 'InsertEnter' or 'CmdlineEnter~/'.
---@param event string
---@param f fun()
function M.on_event(event, f)
	misc.safely('event:' .. event, f)
end

---Run once when any of the filetypes is first set, e.g. 'lua' or 'tex,plaintex'.
---@param filetypes string
---@param f fun()
function M.on_filetype(filetypes, f)
	misc.safely('filetype:' .. filetypes, f)
end

---Re-fire FileType for loaded buffers, only for autocmds in `group`. For
---plugins that attach on FileType but load after it already fired (lazy.nvim
---did this for its lazy-loaded plugins).
---@param group string
function M.refire_filetype(group)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local ft = vim.bo[buf].filetype
		if vim.api.nvim_buf_is_loaded(buf) and ft ~= '' then
			vim.api.nvim_buf_call(buf, function()
				vim.api.nvim_exec_autocmds(
					'FileType',
					{ group = group, pattern = ft, modeline = false }
				)
			end)
		end
	end
end

---Is the plugin installed via vim.pack (not necessarily loaded yet)?
---@param name string
---@return boolean
function M.has(name)
	return pcall(vim.pack.get, { name }, { info = false })
end

---@class rafi.pack.BuildOpts
---@field build fun(path: string) Runs with the plugin (and deps) loaded
---@field is_built? fun(path: string): boolean False runs `build` at startup
---@field deps? string[] Plugins to `:packadd` first, e.g. ones its plugin/ requires

---Register a build step for a plugin. `opts.build(path)` runs when vim.pack
---installs or updates the plugin (PackChanged), after `:packadd` of its deps
---and itself. With `opts.is_built`, the build also runs right away when the
---plugin is installed but `is_built(path)` is false. That covers installs
---vim.pack made before this hook existed: the lockfile sync on the first
---vim.pack call (a fresh `make install`), or an update before the plugin's
---file was sourced.
---@param name string Plugin name, e.g. 'telescope-fzf-native.nvim'
---@param opts rafi.pack.BuildOpts
function M.build(name, opts)
	-- :packadd an installed plugin unless it's already on 'runtimepath', so
	-- its plugin/ files aren't sourced twice.
	local function load(plugin)
		local ok, found = pcall(vim.pack.get, { plugin }, { info = false })
		local rtp = vim.api.nvim_list_runtime_paths()
		if ok and not vim.list_contains(rtp, found[1].path) then
			vim.cmd.packadd(plugin)
		end
	end
	local function run(path)
		for _, dep in ipairs(opts.deps or {}) do
			load(dep)
		end
		load(name)
		opts.build(path)
	end
	vim.api.nvim_create_autocmd('PackChanged', {
		group = vim.api.nvim_create_augroup('rafi.pack.build.' .. name, {}),
		callback = function(ev)
			local data = ev.data
			if data.spec.name == name and data.kind ~= 'delete' then
				run(data.path)
			end
		end,
	})
	if not opts.is_built then
		return
	end
	local ok, plugins = pcall(vim.pack.get, { name }, { info = false })
	local plugin = ok and plugins[1] or nil
	if plugin and not opts.is_built(plugin.path) then
		run(plugin.path)
	end
end

---@class rafi.pack.CommandOpts: vim.api.keyset.user_command
---@field complete? string|fun(arglead: string, line: string, pos: integer): string[]|true

---Define stub user commands that load a plugin on first use and re-run the
---command line against the real command the plugin defines. The stub deletes
---itself before loading, so a load that doesn't define the command reports
---an error instead of calling the stub again forever. The re-run keeps
---modifiers, range or count, bang and arguments. `opts` are the stub's
---command attributes (default `nargs = '*'`); `complete = true` loads the
---plugin on first completion and completes with the real command.
---@param names string|string[]
---@param load fun()
---@param opts? rafi.pack.CommandOpts
function M.command(names, load, opts)
	opts = vim.tbl_extend('keep', opts or {}, { nargs = '*' })
	local stub_opts = vim.deepcopy(opts)
	for _, name in ipairs(type(names) == 'string' and { names } or names) do
		if opts.complete == true then
			local completing = false
			stub_opts.complete = function(_, line)
				-- Still the stub after load(): don't recurse into ourselves.
				if completing then
					return {}
				end
				completing = true
				local ok, items = pcall(function()
					load()
					return vim.fn.getcompletion(line, 'cmdline')
				end)
				completing = false
				return ok and items or {}
			end
		end
		vim.api.nvim_create_user_command(name, function(args)
			pcall(vim.api.nvim_del_user_command, name)
			load()
			if vim.fn.exists(':' .. name) ~= 2 then
				vim.notify(
					('Loading the plugin did not define :%s'):format(name),
					vim.log.levels.ERROR
				)
				return
			end
			local cmd = { cmd = name, args = args.fargs, mods = args.smods }
			if opts.bang then
				cmd.bang = args.bang
			end
			if args.range > 0 and opts.count then
				cmd.count = args.count
			elseif args.range > 0 and opts.range then
				cmd.range = args.range == 1 and { args.line1 }
					or { args.line1, args.line2 }
			end
			vim.api.nvim_cmd(cmd, {})
		end, stub_opts)
	end
end

---Plugins managed by vim.pack, sorted by name. `info = false` skips the
---per-plugin git calls for branches/tags, so listing stays instant.
---@return vim.pack.PlugData[]
function M.list()
	local plugins = vim.pack.get(nil, { info = false })
	table.sort(plugins, function(a, b)
		return a.spec.name:lower() < b.spec.name:lower()
	end)
	return plugins
end

---Add a plugin from a local checkout in dev/<name> if present (like lazy.nvim's
---`dev = true`), otherwise install it from `src` with vim.pack.
---@param name string Directory name under dev/
---@param src string Fallback git URL
function M.dev(name, src)
	local dir = vim.fn.stdpath('config') .. '/dev/' .. name
	if vim.uv.fs_stat(dir) then
		vim.opt.rtp:append(dir)
	else
		vim.pack.add({ src })
	end
end

return M
