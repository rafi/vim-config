-- LSP: Plugins
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			{ 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
			{ 'folke/neodev.nvim', config = true },
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
				virtual_text = { spacing = 4, prefix = '●' },
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
			capabilities = {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			},
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
		},
		---@param opts PluginLspOpts
		config = function(_, opts)
			-- Setup autoformat
			require('rafi.plugins.lsp.format').autoformat = opts.autoformat
			-- Setup formatting, keymaps and highlights.
			require('rafi.config').on_attach(function(client, buffer)
				require('rafi.plugins.lsp.format').on_attach(client, buffer)
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
			local function make_config(server_name)
				local server_opts = vim.tbl_deep_extend('force', {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server_name] or {})

				local exists, module = pcall(require, 'lsp.' .. server_name)
				if exists and module ~= nil then
					local user_config = module.config(server_opts) or {}
					server_opts = vim.tbl_deep_extend('force', server_opts, user_config)
				end
				require('lspconfig')[server_name].setup(server_opts)
			end

			-- Get all the servers that are available thourgh mason-lspconfig
			local have_mason, mason_lspconfig = pcall(require, 'mason-lspconfig')
			if have_mason then
				mason_lspconfig.setup()
				mason_lspconfig.setup_handlers({ make_config })
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
