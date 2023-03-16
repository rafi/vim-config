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
			'hrsh7th/cmp-nvim-lsp',
			'kevinhwang91/nvim-ufo',
			{ 'b0o/SchemaStore.nvim', version = false },
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
			-- LSP Server Settings
			---@type lspconfig.options
			servers = {
				yamlls = {
					filetypes = { 'yaml', 'yaml.ansible', 'yaml.docker-compose' },
				},
				jsonls = {
					on_new_config = function(new_config)
						-- Lazy-load schemastore when needed
						new_config.settings.json.schemas =
							new_config.settings.json.schemas or {}
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
			-- Setup formatting and keymaps
			require('rafi.config').on_attach(function(client, buffer)
				require('rafi.plugins.lsp.format').on_attach(client, buffer)
				require('rafi.plugins.lsp.keymaps').on_attach(client, buffer)
				require('rafi.plugins.lsp.highlight').on_attach(client, buffer)

				if
					vim.b[buffer].diagnostics_disabled or vim.g['diagnostics_disabled']
					or vim.bo[buffer].buftype ~= '' or vim.bo[buffer].filetype == 'helm'
				then
					-- Disable diagnostics if user toggled, or for Helm files.
					vim.diagnostic.disable(buffer)
					return
				end
			end)

			-- Diagnostics signs and highlights
			for type, icon in pairs(require('rafi.config').icons.diagnostics) do
				local hl = 'DiagnosticSign' .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
			end
			vim.diagnostic.config(opts.diagnostics)

			-- Initialize LSP servers and ensure Mason packages

			-- Setup base config for all servers.
			local servers = opts.servers

			local capabilities = require('cmp_nvim_lsp').default_capabilities(
				vim.lsp.protocol.make_client_capabilities()
			)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

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

			-- Setup language servers using mason and mason-lspconfig
			local mason_lspconfig = require('mason-lspconfig')
			mason_lspconfig.setup()
			mason_lspconfig.setup_handlers({ make_config })
		end,
	},

	-----------------------------------------------------------------------------
	{

		'williamboman/mason.nvim',
		cmd = 'Mason',
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
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},

	-----------------------------------------------------------------------------
	{
		'kevinhwang91/nvim-ufo',
		dependencies = 'kevinhwang91/promise-async',
		config = true,
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
				sources = {
					builtins.formatting.stylua,
					builtins.formatting.gofmt,
					builtins.formatting.shfmt,
				},
			}
		end,
	},

}
