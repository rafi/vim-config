-- Util: LSP (mason loader, servers, keymaps, code actions, commands)
-- https://github.com/rafi/vim-config
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/lsp.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua

---@class rafi.util.lsp
local M = {}

---@alias rafi.lsp.Keys {[1]:string, [2]:string|fun(), desc?:string, mode?:string|string[], has?:string|string[], enabled?:fun(buf:integer):boolean, nowait?:boolean}

---@type MasonSettings
M.mason_opts = {
	ui = {
		width = 0.7,
		height = 0.85,
		icons = {
			package_pending = '󰔟',
		},
	},
}

local mason_loaded = false

-- Add and setup mason.nvim once. Must run before any LSP server is enabled,
-- since mason's setup prepends its bin directory to $PATH.
function M.mason()
	if mason_loaded then
		return
	end
	mason_loaded = true
	-- Refresh mason's registry on install and update. No is_built check: the
	-- mason.lua `later` step refreshes the registry before installing tools.
	require('rafi.pack').build('mason.nvim', {
		build = function()
			vim.schedule(function()
				M.mason()
				vim.cmd('MasonUpdate')
			end)
		end,
	})
	vim.pack.add({ 'https://github.com/mason-org/mason.nvim' })
	require('mason').setup(M.mason_opts)
end

-- Code actions
-------------------------------------------------------------------------------

---Apply a code action kind, e.g. `M.action['source.organizeImports']`.
---@type table<string, fun()>
M.action = setmetatable({}, {
	__index = function(_, action)
		return function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { action },
					diagnostics = {},
				},
			})
		end
	end,
})

---@class rafi.lsp.Command: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler
---@field filter? string|vim.lsp.get_clients.Filter
---@field title? string

---@param opts rafi.lsp.Command
function M.execute(opts)
	local filter = opts.filter or {}
	filter = type(filter) == 'string' and { name = filter } or filter
	local buf = vim.api.nvim_get_current_buf()

	---@cast filter vim.lsp.get_clients.Filter
	local client =
		vim.lsp.get_clients(vim.tbl_extend('force', {}, filter, { bufnr = buf }))[1]

	local params = {
		command = opts.command,
		arguments = opts.arguments,
	}
	if opts.open then
		-- trouble.nvim is added by the editor.trouble extra (pack.later).
		require('trouble').open({
			mode = 'lsp_command',
			params = params,
		})
	else
		vim.list_extend(params, { title = opts.title })
		return client:exec_cmd(params, { bufnr = buf }, opts.handler)
	end
end

---List code action kinds supported by clients.
---@param filter? vim.lsp.get_clients.Filter
---@return string[]
function M.code_actions(filter)
	filter = filter or {}
	local ret = {} ---@type string[]
	local clients = vim.lsp.get_clients(filter)
	for _, client in ipairs(clients) do
		-- Server capabilities
		vim.list_extend(
			ret,
			vim.tbl_get(
				client,
				'server_capabilities',
				'codeActionProvider',
				'codeActionKinds'
			) or {}
		)
		-- Dynamic capabilities
		local regs = client.dynamic_capabilities:get('codeActionProvider', filter)
		for _, reg in ipairs(regs or {}) do
			vim.list_extend(
				ret,
				vim.tbl_get(reg, 'registerOptions', 'codeActionKinds') or {}
			)
		end
	end
	local seen, uniq = {}, {} ---@type table<string, boolean>, string[]
	for _, kind in ipairs(ret) do
		if not seen[kind] then
			seen[kind] = true
			uniq[#uniq + 1] = kind
		end
	end
	return uniq
end

-- Keymaps
-------------------------------------------------------------------------------

local key_skip = { mode = true, has = true, enabled = true }

---Set buffer-local keymaps for LSP clients matching filter.
---A spec is mapped only when a client supports its `has` method(s).
---@param filter vim.lsp.get_clients.Filter
---@param specs rafi.lsp.Keys[]
function M.set_keys(filter, specs)
	if not _G.Snacks then
		return
	end
	for _, keys in ipairs(specs) do
		local filters = {} ---@type vim.lsp.get_clients.Filter[]
		if keys.has then
			local methods = type(keys.has) == 'string' and { keys.has } or keys.has --[[@as string[] ]]
			for _, method in ipairs(methods) do
				method = method:find('/') and method or ('textDocument/' .. method)
				filters[#filters + 1] =
					vim.tbl_extend('force', vim.deepcopy(filter), { method = method })
			end
		else
			filters[#filters + 1] = filter
		end

		for _, f in ipairs(filters) do
			local opts = {} ---@type snacks.keymap.set.Opts
			for k, v in pairs(keys) do
				if type(k) ~= 'number' and not key_skip[k] then
					opts[k] = v
				end
			end
			opts.lsp = f
			opts.enabled = keys.enabled
			Snacks.keymap.set(keys.mode or 'n', keys[1], keys[2], opts)
		end
	end
end

-- Options
-------------------------------------------------------------------------------

-- Global values before any LSP buffer, to detect user or plugin changes.
local global_options = {
	foldmethod = vim.go.foldmethod,
	foldexpr = vim.go.foldexpr,
}
local defaults = {} ---@type table<string, boolean>

---Set a window/buffer-local option, unless it was changed by a plugin or
---the user. Returns false if the option wasn't set.
---@param option string
---@param value string|number|boolean
---@return boolean was_set
function M.set_default(option, value)
	local l = vim.api.nvim_get_option_value(option, { scope = 'local' })
	local g = global_options[option]
	if g == nil then
		g = vim.api.nvim_get_option_value(option, { scope = 'global' })
	end

	defaults[('%s=%s'):format(option, value)] = true
	local key = ('%s=%s'):format(option, l)

	if l ~= g and not defaults[key] then
		-- Option does not match global and is not a default value.
		-- Check if it was set by a script in $VIMRUNTIME.
		local info = vim.api.nvim_get_option_info2(option, { scope = 'local' })
		local scriptinfo = vim.tbl_filter(function(e)
			return e.sid == info.last_set_sid
		end, vim.fn.getscriptinfo())
		local by_rtp = #scriptinfo == 1
			and vim.startswith(scriptinfo[1].name, vim.fn.expand('$VIMRUNTIME'))
		if not by_rtp then
			return false
		end
	end

	vim.api.nvim_set_option_value(option, value, { scope = 'local' })
	return true
end

---Run fn(buf, client) for every buffer attached to a client that supports
---the method or matches the filter.
---@param filter vim.lsp.get_clients.Filter
---@param fn fun(buf:integer, client:vim.lsp.Client)
local function on_lsp(filter, fn)
	if _G.Snacks then
		Snacks.util.lsp.on(filter, fn)
		return
	end
	vim.api.nvim_create_autocmd('LspAttach', {
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if
				client
				and (not filter.name or client.name == filter.name)
				and (not filter.method or client:supports_method(filter.method, ev.buf))
			then
				fn(ev.buf, client)
			end
		end,
	})
end

-- Setup
-------------------------------------------------------------------------------

---@class rafi.lsp.Opts
---@field diagnostics vim.diagnostic.Opts|{virtual_text?: {prefix?: string|fun()}}
---@field inlay_hints {enabled: boolean, exclude: string[]}
---@field codelens {enabled: boolean}
---@field folds {enabled: boolean}
---@field config? vim.lsp.Config Default config for all servers ('*')
---@field servers table<string, boolean> Enabled/disabled servers
---@field keys table<string, rafi.lsp.Keys[]> Keymaps per server ('*' for all)

---@param opts rafi.lsp.Opts
function M.setup(opts)
	-- Keymaps, '*' first so server-specific keys override.
	local names = vim.tbl_keys(opts.keys or {})
	table.sort(names)
	for _, server in ipairs(names) do
		M.set_keys({ name = server ~= '*' and server or nil }, opts.keys[server])
	end

	-- Inlay hints
	if opts.inlay_hints.enabled then
		on_lsp({ method = 'textDocument/inlayHint' }, function(buffer)
			if
				vim.api.nvim_buf_is_valid(buffer)
				and vim.bo[buffer].buftype == ''
				and not vim.tbl_contains(
					opts.inlay_hints.exclude,
					vim.bo[buffer].filetype
				)
			then
				vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
			end
		end)
	end

	-- Folds
	if opts.folds.enabled then
		on_lsp({ method = 'textDocument/foldingRange' }, function()
			if M.set_default('foldmethod', 'expr') then
				M.set_default('foldexpr', 'v:lua.vim.lsp.foldexpr()')
			end
		end)
	end

	-- Code lens
	if opts.codelens.enabled and vim.lsp.codelens then
		on_lsp({ method = 'textDocument/codeLens' }, function(buffer)
			vim.lsp.codelens.refresh()
			vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
				buffer = buffer,
				callback = vim.lsp.codelens.refresh,
			})
		end)
	end

	-- Diagnostics
	local diagnostics = vim.deepcopy(opts.diagnostics)
	local vt = diagnostics.virtual_text
	if type(vt) == 'table' and vt.prefix == 'icons' then
		vt.prefix = function(diagnostic)
			local icons = require('rafi.util.icons').diagnostics
			for d, icon in pairs(icons) do
				if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
					return icon
				end
			end
			return '●'
		end
	end
	vim.diagnostic.config(diagnostics)

	if opts.config then
		vim.lsp.config('*', opts.config)
	end

	-- Servers configured in after/lsp/<server>.lua. Enabled servers mason
	-- knows are installed and enabled by mason-lspconfig, the rest directly.
	local mason_all = vim.tbl_keys(
		require('mason-lspconfig.mappings').get_mason_map().lspconfig_to_package
	)
	local install, exclude = {}, {} ---@type string[], string[]
	for server, enabled in pairs(opts.servers) do
		if not enabled then
			exclude[#exclude + 1] = server
		elseif vim.tbl_contains(mason_all, server) then
			install[#install + 1] = server
		else
			vim.lsp.enable(server)
		end
	end
	require('mason-lspconfig').setup({
		ensure_installed = install,
		automatic_enable = { exclude = exclude },
	})
end

return M
