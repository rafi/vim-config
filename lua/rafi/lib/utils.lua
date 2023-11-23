-- General utilities
-- https://github.com/rafi/vim-config

local root_patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn' }

local M = {}

local augroup_lsp_attach = vim.api.nvim_create_augroup('rafi_lsp_attach', {})

---@param on_attach fun(client:lsp.Client, buffer:integer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd('LspAttach', {
		group = augroup_lsp_attach,
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client ~= nil then
				on_attach(client, buffer)
			end
		end,
	})
end

---@param plugin string
---@return boolean
function M.has(plugin)
	-- return require('lazy.core.config').plugins[plugin] ~= nil
	return require('lazy.core.config').spec.plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd('User', {
		pattern = 'VeryLazy',
		callback = function()
			fn()
		end,
	})
end

---@param name string
---@return table
function M.opts(name)
	local plugin = require('lazy.core.config').plugins[name]
	if not plugin then
		return {}
	end
	local Plugin = require('lazy.core.plugin')
	return Plugin.values(plugin, 'opts', false)
end

-- Find the root directory by searching for the version-control dir
---@return string
function M.get_root()
	local cwd = vim.loop.cwd()
	if cwd == '' or cwd == nil then
		return ''
	end
	local ok, cache = pcall(vim.api.nvim_buf_get_var, 0, 'project_dir')
	if ok and cache then
		local _, last_cwd =
			pcall(vim.api.nvim_buf_get_var, 0, 'project_dir_last_cwd')
		if cwd == last_cwd then
			return cache
		end
	end

	local root = vim.fs.find(root_patterns, { path = cwd, upward = true })[1]
	root = root and vim.fs.dirname(root) or vim.loop.cwd() or ''
	vim.api.nvim_buf_set_var(0, 'project_dir', root)
	vim.api.nvim_buf_set_var(0, 'project_dir_last_cwd', cwd)
	return root
end

---@type table<string,LazyFloat>
local terminals = {}

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyCmdOptions|{interactive?:boolean, esc_esc?:false, ctrl_hjkl?:false}
function M.float_term(cmd, opts)
	opts = vim.tbl_deep_extend('force', {
		ft = 'lazyterm',
		size = { width = 0.9, height = 0.9 },
	}, opts or {}, { persistent = true })
	---@cast opts LazyCmdOptions|{interactive?:boolean, esc_esc?:false, ctrl_hjkl?:false}

	local termkey = vim.inspect({
		cmd = cmd or 'shell',
		cwd = opts.cwd,
		env = opts.env,
		count = vim.v.count1,
	})

	if terminals[termkey] and terminals[termkey]:buf_valid() then
		terminals[termkey]:toggle()
	else
		terminals[termkey] = require('lazy.util').float_term(cmd, opts)
		local buf = terminals[termkey].buf
		vim.b[buf].lazyterm_cmd = cmd
		if opts.esc_esc == false then
			vim.keymap.set('t', '<esc>', '<esc>', { buffer = buf, nowait = true })
		end
		if opts.ctrl_hjkl == false then
			vim.keymap.set('t', '<c-h>', '<c-h>', { buffer = buf, nowait = true })
			vim.keymap.set('t', '<c-j>', '<c-j>', { buffer = buf, nowait = true })
			vim.keymap.set('t', '<c-k>', '<c-k>', { buffer = buf, nowait = true })
			vim.keymap.set('t', '<c-l>', '<c-l>', { buffer = buf, nowait = true })
		end

		vim.api.nvim_create_autocmd('BufEnter', {
			buffer = buf,
			callback = function()
				vim.cmd.startinsert()
			end,
		})
	end

	return terminals[termkey]
end

return M
