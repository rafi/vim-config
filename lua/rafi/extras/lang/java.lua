-- Java: nvim-jdtls (jdtls started per java buffer, mason installs jdtls)
-- Mason installs jdtls. nvim-jdtls starts it per buffer, with a workspace
-- per project, so lspconfig must not. No debugger or test support.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/java.lua
local pack = require('rafi.pack')

require('rafi.util.lang').add({
	servers = { jdtls = false },
	tools = { 'jdtls' },
})

local mason_dir = (vim.env.MASON or vim.fn.stdpath('data') .. '/mason')

-- Where to find a project's root, from jdtls' lspconfig root markers.
---@param path string
---@return string?
local function root_dir(path)
	local markers = vim.lsp.config.jdtls and vim.lsp.config.jdtls.root_markers
	return vim.fs.root(path, markers or { '.git', 'mvnw', 'gradlew' })
end

-- jdtls launch command. Each project gets its own config and workspace
-- dirs, so projects don't share state.
---@param fname string
---@return string[]
local function full_cmd(fname)
	local cmd = { vim.fn.exepath('jdtls') }
	local lombok_jar = mason_dir .. '/share/jdtls/lombok.jar'
	if vim.uv.fs_stat(lombok_jar) then
		table.insert(cmd, string.format('--jvm-arg=-javaagent:%s', lombok_jar))
	end
	local root = root_dir(fname)
	local project_name = root and vim.fs.basename(root)
	if project_name then
		local base = vim.fn.stdpath('cache') .. '/jdtls/' .. project_name
		vim.list_extend(cmd, {
			'-configuration',
			base .. '/config',
			'-data',
			base .. '/workspace',
		})
	end
	return cmd
end

-- Start jdtls for the buffer, or attach it to the client for the same root.
---@param buf integer
local function attach_jdtls(buf)
	local fname = vim.api.nvim_buf_get_name(buf)
	-- Client defaults from lspconfig's '*' config, plus blink.cmp capabilities.
	local capabilities =
		vim.deepcopy(vim.lsp.config['*'] and vim.lsp.config['*'].capabilities or {})
	local ok, blink = pcall(require, 'blink.cmp')
	if ok then
		capabilities =
			vim.tbl_deep_extend('force', capabilities, blink.get_lsp_capabilities())
	end
	-- Config can be extended through vim.g.jdtls (table).
	local config = vim.tbl_deep_extend('force', {
		cmd = full_cmd(fname),
		root_dir = root_dir(fname),
		init_options = { bundles = {} },
		settings = {
			java = {
				inlayHints = { parameterNames = { enabled = 'all' } },
			},
		},
		capabilities = capabilities,
	}, vim.g.jdtls or {})
	require('jdtls').start_or_attach(config)
end

-- Keymaps for buffers jdtls attached to.
---@param buf integer
local function set_keymaps(buf)
	local jdtls = require('jdtls')
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
	end
	map('n', '<leader>cxv', jdtls.extract_variable_all, 'Extract Variable')
	map('n', '<leader>cxc', jdtls.extract_constant, 'Extract Constant')
	map('n', '<leader>cgs', jdtls.super_implementation, 'Goto Super')
	map('n', '<leader>cgS', function()
		require('jdtls.tests').goto_subjects()
	end, 'Goto Subjects')
	-- NOTE: Conflict: lang.java wins over core '<leader>co' (source
	-- organizeImports) in jdtls buffers when enabled
	map('n', '<leader>co', jdtls.organize_imports, 'Organize Imports')
	map('x', '<leader>cxm', function()
		vim.cmd('normal! \27')
		jdtls.extract_method(true)
	end, 'Extract Method')
	map('x', '<leader>cxv', function()
		vim.cmd('normal! \27')
		jdtls.extract_variable_all(true)
	end, 'Extract Variable')
	map('x', '<leader>cxc', function()
		vim.cmd('normal! \27')
		jdtls.extract_constant(true)
	end, 'Extract Constant')

	require('rafi.util.mini').on_which_key(function()
		require('which-key').add({
			{ '<leader>cx', group = 'extract', mode = { 'n', 'x' }, buffer = buf },
		})
	end)
end

local loaded = false

-- Load nvim-jdtls and attach it to every java buffer on FileType.
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/mfussenegger/nvim-jdtls' })

	local group = vim.api.nvim_create_augroup('rafi.lang.java', {})
	vim.api.nvim_create_autocmd('FileType', {
		group = group,
		pattern = 'java',
		callback = function(ev)
			attach_jdtls(ev.buf)
		end,
	})

	-- Set keymaps once jdtls is fully attached.
	vim.api.nvim_create_autocmd('LspAttach', {
		group = group,
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if client and client.name == 'jdtls' then
				set_keymaps(ev.buf)
			end
		end,
	})
	-- No direct attach for the triggering buffer: mini.misc re-sources the
	-- ftplugin of open java buffers after this loader returns, which fires
	-- FileType again and runs the autocmd above.
end

pack.on_filetype('java', load)
