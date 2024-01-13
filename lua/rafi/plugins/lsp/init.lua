-- LSP: Plugins
-- https://github.com/rafi/vim-config

-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua

return {

	-----------------------------------------------------------------------------
	{
		'neovim/nvim-lspconfig',
		event = 'LazyFile',
		-- stylua: ignore
		dependencies = {
			{ 'folke/neoconf.nvim', cmd = 'Neoconf', config = false, dependencies = { 'nvim-lspconfig' } },
			{ 'folke/neodev.nvim', opts = {} },
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		},
		---@class PluginLspOpts
		opts = {
			-- Options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = 'if_many',
					prefix = '●',
				},
				severity_sort = true,
				float = {
					show_header = true,
					border = 'rounded',
					source = 'always',
				},
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server
			-- to provide the inlay hints.
			inlay_hints = {
				enabled = false,
			},
			-- Add any global capabilities here
			capabilities = {},
			-- Formatting options for vim.lsp.buf.format
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			---@type lspconfig.options
			---@diagnostic disable: missing-fields
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							completion = { callSnippet = 'Replace' },
						},
					},
				},
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require('typescript').setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ['*'] = function(server, opts) end,
			},
		},
		---@param opts PluginLspOpts
		config = function(_, opts)
			local Util = require('lazyvim.util')
			if Util.has('neoconf.nvim') then
				local plugin = require('lazy.core.config').spec.plugins['neoconf.nvim']
				require('neoconf').setup(
					require('lazy.core.plugin').values(plugin, 'opts', false)
				)
			end

			-- Setup autoformat
			Util.format.register(Util.lsp.formatter())

			-- Setup formatting, keymaps and highlights.
			Util.lsp.on_attach(function(client, buffer)
				require('rafi.plugins.lsp.keymaps').on_attach(client, buffer)
				if not require('lazyvim.util').has('vim-illuminate') then
					require('rafi.plugins.lsp.highlight').on_attach(client, buffer)
				end

				if vim.diagnostic.is_disabled() or vim.bo[buffer].buftype ~= '' then
					vim.diagnostic.disable(buffer)
					return
				end
			end)

			local register_capability = vim.lsp.handlers['client/registerCapability']

			---@diagnostic disable-next-line: duplicate-set-field
			vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
				local ret = register_capability(err, res, ctx)
				local client_id = ctx.client_id
				---@type lsp.Client|nil
				local client = vim.lsp.get_client_by_id(client_id)
				local buffer = vim.api.nvim_get_current_buf()
				if client ~= nil then
					require('rafi.plugins.lsp.keymaps').on_attach(client, buffer)
				end
				return ret
			end

			-- Diagnostics signs and highlights.
			-- Support vim.fn.sign_define legacy API, and use icons from
			-- config/init.lua if none are set in opts.
			local set_opts_signs = vim.fn.has('nvim-0.10') == 1
			if set_opts_signs then
				if type(opts.diagnostics.signs) == 'table' then
					if table(opts.diagnostics.signs.text) == 'table' then
						set_opts_signs = false
					else
						opts.diagnostics.signs.text = {}
					end
				else
					opts.diagnostics.signs = { text = {} }
				end
			end
			if set_opts_signs or vim.fn.has('nvim-0.10') == 0 then
				for type, icon in pairs(require('lazyvim.config').icons.diagnostics) do
					if set_opts_signs then
						local severity = vim.diagnostic.severity[type:upper()]
						opts.diagnostics.signs.text[severity] = icon
					else
						local hl = 'DiagnosticSign' .. type
						vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
					end
				end
			end

			-- Setup inlay-hints
			if opts.inlay_hints.enabled then
				Util.lsp.on_attach(function(client, buffer)
					if client.supports_method('textDocument/inlayHint') then
						Util.toggle.inlay_hints(buffer, true)
					end
				end)
			end

			if
				type(opts.diagnostics.virtual_text) == 'table'
				and opts.diagnostics.virtual_text.prefix == 'icons'
			then
				opts.diagnostics.virtual_text.prefix = vim.fn.has('nvim-0.10') == 0
						and '●'
					or function(diagnostic)
						local icons = require('lazyvim.config').icons.diagnostics
						for d, icon in pairs(icons) do
							if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
								return icon
							end
						end
					end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			-- Enable rounded borders in :LspInfo window.
			require('lspconfig.ui.windows').default_options.border = 'rounded'

			-- Initialize LSP servers and ensure Mason packages

			-- Setup base config for all servers.
			local servers = opts.servers
			local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
			local capabilities = vim.tbl_deep_extend(
				'force',
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			-- Combine base config for each server and merge user-defined settings.
			-- These can be overridden locally by lua/lsp/<server_name>.lua
			---@param server_name string
			local function make_config(server_name)
				local server_opts = vim.tbl_deep_extend('force', {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server_name] or {})

				if opts.setup[server_name] then
					if opts.setup[server_name](server_name, server_opts) then
						return
					end
				elseif opts.setup['*'] then
					if opts.setup['*'](server_name, server_opts) then
						return
					end
				end

				local exists, module = pcall(require, 'lsp.' .. server_name)
				if exists and module ~= nil then
					local user_config = module.config(server_opts) or {}
					server_opts = vim.tbl_deep_extend('force', server_opts, user_config)
				end
				require('lspconfig')[server_name].setup(server_opts)
			end

			-- Get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, 'mason-lspconfig')
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(
					require('mason-lspconfig.mappings.server').lspconfig_to_package
				)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot
					-- be installed with mason-lspconfig
					if
						server_opts.mason == false
						or not vim.tbl_contains(all_mslp_servers, server)
					then
						make_config(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			if have_mason then
				mlsp.setup({
					ensure_installed = ensure_installed,
					handlers = { make_config },
				})
			end

			if Util.lsp.get_config('denols') and Util.lsp.get_config('tsserver') then
				local is_deno =
					require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc')
				Util.lsp.disable('tsserver', is_deno)
				Util.lsp.disable('denols', function(root_dir)
					return not is_deno(root_dir)
				end)
			end
		end,
	},

	-----------------------------------------------------------------------------
	{
		'williamboman/mason.nvim',
		cmd = 'Mason',
		build = ':MasonUpdate',
		keys = { { '<leader>mm', '<cmd>Mason<cr>', desc = 'Mason' } },
		opts = {
			ensure_installed = {},
			ui = {
				border = 'rounded',
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require('mason').setup(opts)
			local mr = require('mason-registry')
			mr:on('package:install:success', function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require('lazy.core.handler.event').trigger({
						event = 'FileType',
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
}
