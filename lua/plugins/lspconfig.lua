-- plugin: nvim-lspconfig
-- see: https://github.com/neovim/nvim-lspconfig
--      https://github.com/kabouzeid/nvim-lspinstall
--      https://github.com/kosayoda/nvim-lightbulb
--      https://github.com/folke/lua-dev.nvim
-- rafi settings

local opts = { noremap=true, silent=true }

-- global
vim.api.nvim_set_keymap('n', '<Leader>a', ':lua require("user").diagnostic.publish_loclist(true)<CR>', opts)

-- buffer attached
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	-- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- See https://github.com/ray-x/lsp_signature.nvim
	-- require('lsp_signature').on_attach({
	-- 	bind = true,
	-- 	hint_enable = true,
	-- 	hint_prefix = ' ',
	-- 	handler_opts = { border = 'single' },
	-- })

	-- Mappings.
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	-- buf_set_keymap('n', 'K', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', ',s', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	-- buf_set_keymap('n', ',s', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)
	buf_set_keymap('n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', ',wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	-- buf_set_keymap('n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', ',rn', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<Leader>f', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
	-- buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', '<Leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)
	buf_set_keymap('v', '<Leader>ca', ':<C-u>lua require("lspsaga.codeaction").range_code_action()<CR>', opts)
	buf_set_keymap('n', '<Leader>ce', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	-- buf_set_keymap('n', '<Leader>q', ':lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", ",f", '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
	end
	if client.resolved_capabilities.document_range_formatting then
		buf_set_keymap("v", ",f", '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
	end

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
			hi! LspReferenceRead ctermbg=237 guibg=#3D3741
			hi! LspReferenceText ctermbg=237 guibg=#373B41
			hi! LspReferenceWrite ctermbg=237 guibg=#374137
			augroup lsp_document_highlight
			autocmd! * <buffer>
			autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
			autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]], false)
	end
end

local lua_settings = {
	Lua = {
		runtime = { version = 'LuaJIT', path = vim.split(package.path, ';'), },
		diagnostics = {
			enable = true,
			globals = {'vim', 'use', 'describe', 'it', 'assert', 'before_each', 'after_each'},
		},
		workspace = {
			preloadFileSize = 400,
			library = {
				[vim.fn.expand('$VIMRUNTIME/lua')] = true,
				[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
			},
		},
	}
}

vim.fn.sign_define(
	"LspDiagnosticsSignError",
	{ texthl = "LspDiagnosticsSignError",
		text = "✘",
		numhl = "LspDiagnosticsSignError"
	}
)
vim.fn.sign_define(
	"LspDiagnosticsSignWarning",
	{
		texthl = "LspDiagnosticsSignWarning",
		text = "⚠",
		numhl = "LspDiagnosticsSignWarning"
	}
)
vim.fn.sign_define(
	"LspDiagnosticsSignHint",
	{
		texthl = "LspDiagnosticsSignHint",
		text = "",
		numhl = "LspDiagnosticsSignHint"
	}
)
vim.fn.sign_define(
	"LspDiagnosticsSignInformation",
	{
		texthl = "LspDiagnosticsSignInformation",
		text = "ⁱ",
		numhl = "LspDiagnosticsSignInformation"
	}
)

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
	"   (Text)",
	"   (Method)",
	"   (Function)",
	"   (Constructor)",
	" ﴲ  (Field)",
	"   (Variable)",
	"   (Class)",
	" ﰮ  (Interface)",
	"   (Module)",
	" 襁 (Property)",
	"   (Unit)",
	"   (Value)",
	" 練 (Enum)",
	"   (Keyword)",
	" ﬌  (Snippet)",
	"   (Color)",
	"   (File)",
	"   (Reference)",
	"   (Folder)",
	"   (EnumMember)",
	"   (Constant)",
	"   (Struct)",
	"   (Event)",
	"   (Operator)",
	"   (TypeParameter)"
}

-- require('lsp-status').config({
-- 	indicator_errors = '  ',
-- 	indicator_warning = '  ',
-- 	indicator_info = '  ',
-- 	indicator_hint = '  ',
-- 	status_symbol = '',
-- 	current_function = false,
-- })

-- Enable diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = true,
		signs = true,
		update_in_insert = false,
	}
)

vim.lsp.handlers["textDocument/references"] = function(_, _, result)
	require('user').diagnostic.set_qflist(result)
end

local function make_config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			'documentation',
			'detail',
			'additionalTextEdits',
		}
	}
	return {
		on_attach = on_attach,
	}
end

local function setup_servers()
	local lsp_config = require('lspconfig')
	local lsp_install = require('lspinstall')
	lsp_install.setup()
	local servers = lsp_install.installed_servers()
	for _, server in pairs(servers) do
		local config = make_config()

		if server == 'lua' then
			-- See https://github.com/folke/lua-dev.nvim
			config.settings = lua_settings
			config = require('lua-dev').setup({
				lspconfig = config,
				library = {
					vimruntime = true, -- runtime path
					types = true, -- full signature, docs and completion
					plugins = { 'plenary.nvim' },
				},
			})
		elseif server == 'yaml' then
			config.init_options = {
				config = {
					yaml = {
						schemas = {
							kubernetes = "helm/**.yaml"
						}
					}
				}
			}
		elseif server == 'diagnosticls' then
			-- See lua/plugins/diagnosticls.lua
			local diagnosticls = require('plugins.diagnosticls')
			config.init_options = diagnosticls.init_options
			config.filetypes = diagnosticls.filetypes
		end

		lsp_config[server].setup(config)
	end

	-- Reload if files were supplied in command-line arguments
	if vim.fn.argc() > 0 and not vim.o.modified then
		vim.cmd('windo e') -- triggers the FileType autocmd that starts the server
	end
end

-- main

if vim.fn.has('vim_starting') then
	setup_servers()

	-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
	require'lspinstall'.post_install_hook = function ()
		setup_servers() -- reload installed servers
		if not vim.o.modified then
			vim.cmd('bufdo e') -- this triggers the FileType autocmd that starts the server
		end
	end

	-- See https://github.com/kosayoda/nvim-lightbulb
	-- vim.cmd [[ autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb() ]]
	vim.cmd [[ autocmd CursorHold * lua require'nvim-lightbulb'.update_lightbulb() ]]
end
