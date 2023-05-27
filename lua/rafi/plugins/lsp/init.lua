-- LSP: Plugins
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			{ 'folke/neoconf.nvim', cmd = 'Neoconf', opts = {} },
			{ 'folke/neodev.nvim', opts = {} },
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			{
				'hrsh7th/cmp-nvim-lsp',
				cond = function()
					return require('rafi.config').has('nvim-cmp')
				end,
			},
			'b0o/SchemaStore.nvim',
			'rafi/neoconf-venom.nvim',
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
			-- Automatically format on save
			autoformat = false,
			-- Options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- Add any global capabilities here
			capabilities = {},
			-- Enable this to show formatters used in a notification
			-- Useful for debugging formatter issues
			format_notify = false,
			-- LSP Server Settings
			---@type lspconfig.options
			servers = {
				yamlls = {
					filetypes = { 'yaml', 'yaml.ansible', 'yaml.docker-compose' },
				},
				jsonls = {
					on_new_config = function(new_config)
						-- Lazy-load schemastore when needed
						new_config.settings.json.schemas = new_config.settings.json.schemas
							or {}
						vim.list_extend(
							new_config.settings.json.schemas,
							require('schemastore').json.schemas()
						)
					end,
					settings = {
						json = {
							format = { enable = true },
							validate = { enable = true },
						},
					},
				},
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
			-- Setup autoformat
			require('rafi.plugins.lsp.format').setup(opts)
			-- Setup formatting, keymaps and highlights.
			---@param client lsp.Client
			---@param buffer integer
			require('rafi.config').on_attach(function(client, buffer)
				require('rafi.plugins.lsp.keymaps').on_attach(client, buffer)
				require('rafi.plugins.lsp.highlight').on_attach(client, buffer)

				if vim.diagnostic.is_disabled() or vim.bo[buffer].buftype ~= '' then
					vim.diagnostic.disable(buffer)
					return
				end
			end)

			-- Diagnostics signs and highlights
			for type, icon in pairs(require('rafi.config').icons.diagnostics) do
				local hl = 'DiagnosticSign' .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
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

			-- See https://github.com/rafi/neoconf-venom.nvim
			require('venom').setup()

			-- Initialize LSP servers and ensure Mason packages

			-- Setup base config for all servers.
			local servers = opts.servers
			local capabilities = vim.tbl_deep_extend(
				'force',
				{},
				vim.lsp.protocol.make_client_capabilities(),
				require('cmp_nvim_lsp').default_capabilities(),
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
		'jose-elias-alvarez/null-ls.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = { 'williamboman/mason.nvim' },
		opts = function()
			local builtins = require('null-ls').builtins
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
			return {
				fallback_severity = vim.diagnostic.severity.INFO,
				should_attach = function(bufnr)
					return not vim.api.nvim_buf_get_name(bufnr):match('^[a-z]+://')
				end,
				root_dir = require('null-ls.utils').root_pattern(
					'.git',
					'_darcs',
					'.hg',
					'.bzr',
					'.svn',
					'.null-ls-root',
					'.neoconf.json',
					'Makefile'
				),
				sources = {
					builtins.formatting.stylua,
					builtins.formatting.shfmt,
				},
			}
		end,
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
						['h'] = actions.close_fold,
						['l'] = actions.open_fold,
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
