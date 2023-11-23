-- LSP: Plugins
-- https://github.com/rafi/vim-config

-- This is part of LazyVim's code, with my modifications.
-- See: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua

return {

	-----------------------------------------------------------------------------
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			{ 'folke/neoconf.nvim', cmd = 'Neoconf', config = false, dependencies = { 'nvim-lspconfig' } },
			{ 'folke/neodev.nvim', opts = {} },
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			{
				'hrsh7th/cmp-nvim-lsp',
				cond = function()
					return require('rafi.lib.utils').has('nvim-cmp')
				end,
			},
		},
		---@class PluginLspOpts
		opts = {
			-- Options for vim.diagnostic.config()
			diagnostics = {
				signs = true,
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
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = false,
			},
			-- Add any global capabilities here
			capabilities = {},
			-- Automatically format on save
			autoformat = false,
			-- Options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- Enable this to show formatters used in a notification
			-- Useful for debugging formatter issues
			format_notify = false,
			-- LSP Server Settings
			---@type lspconfig.options
			---@diagnostic disable: missing-fields
			servers = {
				-- jsonls = {},
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
			if require('rafi.lib.utils').has('neoconf.nvim') then
				local plugin = require('lazy.core.config').spec.plugins['neoconf.nvim']
				require('neoconf').setup(require('lazy.core.plugin').values(plugin, 'opts', false))
			end
			-- Setup autoformat
			require('rafi.plugins.lsp.format').setup(opts)
			-- Setup formatting, keymaps and highlights.
			local lsp_on_attach = require('rafi.lib.utils').on_attach
			---@param client lsp.Client
			---@param buffer integer
			lsp_on_attach(function(client, buffer)
				require('rafi.plugins.lsp.keymaps').on_attach(client, buffer)
				require('rafi.plugins.lsp.highlight').on_attach(client, buffer)

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

			-- Diagnostics signs and highlights
			for type, icon in pairs(require('rafi.config').icons.diagnostics) do
				local hl = 'DiagnosticSign' .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
			end

			-- Setup inlay-hints
			local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
			if opts.inlay_hints.enabled and inlay_hint then
				lsp_on_attach(function(client, buffer)
					if client.supports_method('textDocument/inlayHint') then
						inlay_hint(buffer, true)
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
						local icons = require('rafi.config').icons.diagnostics
						for d, icon in pairs(icons) do
							if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
								return icon
							end
						end
					end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

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

			-- Get all the servers that are available thourgh mason-lspconfig
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

			-- Enable rounded borders in :LspInfo window.
			require('lspconfig.ui.windows').default_options.border = 'rounded'
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

	-----------------------------------------------------------------------------
	{
		'mhartington/formatter.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
		opts = function(_, opts)
			opts = opts or {}
			local defaults = {
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					lua = { require('formatter.filetypes.lua').stylua },
				},
			}
			opts = vim.tbl_extend('keep', opts, defaults)
			return opts
		end,
		config = true,
	},

	-----------------------------------------------------------------------------
	{
		'dnlhc/glance.nvim',
		cmd = 'Glance',
		keys = {
			{ 'gpd', '<cmd>Glance definitions<CR>' },
			{ 'gpr', '<cmd>Glance references<CR>' },
			{ 'gpy', '<cmd>Glance type_definitions<CR>' },
			{ 'gpi', '<cmd>Glance implementations<CR>' },
		},
		opts = function()
			local actions = require('glance').actions
			return {
				folds = {
					fold_closed = '󰅂', -- 󰅂 
					fold_open = '󰅀', -- 󰅀 
					folded = true,
				},
				mappings = {
					list = {
						['<C-u>'] = actions.preview_scroll_win(5),
						['<C-d>'] = actions.preview_scroll_win(-5),
						['sg'] = actions.jump_vsplit,
						['sv'] = actions.jump_split,
						['st'] = actions.jump_tab,
						['p'] = actions.enter_win('preview'),
					},
					preview = {
						['q'] = actions.close,
						['p'] = actions.enter_win('list'),
					},
				},
			}
		end,
	},
}
