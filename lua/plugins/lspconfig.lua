-- plugin: nvim-lspconfig
-- see: https://github.com/neovim/nvim-lspconfig
--      https://github.com/kabouzeid/nvim-lspinstall
--      https://github.com/ray-x/lsp_signature.nvim
--      https://github.com/kosayoda/nvim-lightbulb
-- rafi settings

-- Buffer attached
local on_attach = function(client, bufnr)
	local function map_buf(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	-- local function opt_buf(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Disable diagnostics for Helm template files
	if vim.bo[bufnr].buftype ~= '' or vim.bo[bufnr].filetype == 'helm' then
		vim.lsp.diagnostic.disable()
		return
	end

	if client.config.flags then
		client.config.flags.allow_incremental_sync = true
		client.config.flags.debounce_text_changes  = 100
	end

	-- Keyboard mappings
	local opts = { noremap = true, silent = true }
	map_buf('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	map_buf('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	map_buf('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	map_buf('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	map_buf('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	map_buf('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	map_buf('n', ',s', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	map_buf('n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	map_buf('n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	map_buf('n', ',wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	map_buf('n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	map_buf('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	map_buf('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	map_buf('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	map_buf('n', '<Leader>ce', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

	-- lspsaga
	-- buf_set_keymap('n', '<Leader>f', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
	-- buf_set_keymap('n', 'K', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
	-- buf_set_keymap('n', ',s', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)
	-- buf_set_keymap('n', ',rn', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
	-- buf_set_keymap('n', '<Leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)
	-- buf_set_keymap('v', '<Leader>ca', ':<C-u>lua require("lspsaga.codeaction").range_code_action()<CR>', opts)

	-- See https://github.com/ray-x/lsp_signature.nvim
	-- require('lsp_signature').on_attach({
	-- 	bind = true,
	-- 	check_pumvisible = true,
	-- 	hint_enable = false,
	-- 	hint_prefix = ' ',  --  
	-- 	handler_opts = { border = 'rounded' },
	-- 	zindex = 50,
	-- }, bufnr)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		map_buf('n', ',f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
	end
	if client.resolved_capabilities.document_range_formatting then
		map_buf('x', ',f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
	end

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
			highlight! LspReferenceRead ctermbg=237 guibg=#3D3741
			highlight! LspReferenceText ctermbg=237 guibg=#373B41
			highlight! LspReferenceWrite ctermbg=237 guibg=#374137
			augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]], false)
	end
end

-- Diagnostics signs and highlights
--   Error:   ✘
--   Warn:  ⚠ 
--   Hint:  
--   Info:   ⁱ
local signs = { Error = '✘', Warn = '', Hint = '', Info = 'ⁱ'}
for type, icon in pairs(signs) do
	local hl = 'DiagnosticSign' .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

-- Setup CompletionItemKind symbols, see lua/lsp_kind.lua
-- require('lsp_kind').init()

-- Configure diagnostics publish settings
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = true,
		underline = false,
		update_in_insert = false,
		virtual_text = {
			spacing = 4,
			-- prefix = '',
		}
	}
)

-- Configure hover (normal K) handle
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
	vim.lsp.handlers.hover, { border = 'rounded' }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
	vim.lsp.handlers.signature_help, { border = 'rounded' }
)

-- Open references in quickfix window and jump to first item.
-- local on_references = vim.lsp.handlers['textDocument/references']
-- vim.lsp.handlers['textDocument/references'] = vim.lsp.with(
-- 	on_references, {
-- 		-- Use location list instead of quickfix list
-- 		loclist = true,
-- 	}
-- )
-- vim.lsp.handlers['textDocument/references'] = function(_, _, result, _, bufnr, _)
-- 	if not result or vim.tbl_isempty(result) then
-- 		vim.notify('No references found')
-- 	else
-- 		vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(result, bufnr))
-- 		require('user').qflist.open()
-- 		-- vim.api.nvim_command('.cc')
-- 	end
-- end

-- Combine base config for each server and merge user-defined settings.
local function make_config(server_name)
	-- Setup base config for each server.
	local c = {}
	c.on_attach = on_attach
	c.capabilities = vim.lsp.protocol.make_client_capabilities()
	c.capabilities = require('cmp_nvim_lsp').update_capabilities(c.capabilities)
	c.flags = {
		debounce_text_changes = 150,
	}

	-- cmp_nvim_lsp enables following options:
	--   completionItem = {
	--     commitCharactersSupport = true,
	--     deprecatedSupport = true,
	--     documentationFormat = { "markdown", "plaintext" },
	--     insertReplaceSupport = true,
	--     labelDetailsSupport = true,
	--     preselectSupport = true,
	--     resolveSupport = {
	--       properties = { "documentation", "detail", "additionalTextEdits" }
	--     },
	--     snippetSupport = true,
	--     tagSupport = {
	--       valueSet = { 1 }
	--     }
	--   }

	-- Merge user-defined lsp settings.
	-- These can be overridden locally by lua/lsp-local/<server_name>.lua
	local exists, module = pcall(require, 'lsp-local.'..server_name)
	if not exists then
		exists, module = pcall(require, 'lsp.'..server_name)
	end
	if exists then
		local user_config = module.config(c)
		for k, v in pairs(user_config) do c[k] = v end
	end

	return c
end

-- Iterate and setup all language servers and trigger FileType in windows.
local function setup_servers()
	local lsp_install = require('lspinstall')
	lsp_install.setup()
	local servers = lsp_install.installed_servers()
	for _, server in pairs(servers) do
		local config = make_config(server)
		require'lspconfig'[server].setup(config)
	end

	-- Reload if files were supplied in command-line arguments
	if vim.fn.argc() > 0 and not vim.o.modified then
		vim.cmd('windo e') -- triggers the FileType autocmd that starts the server
	end
end

-- main

if vim.fn.has('vim_starting') then
	local lsp_installer = require('nvim-lsp-installer')

	lsp_installer.on_server_ready(function(server)
		local opts = make_config(server.name)
		server:setup(opts)
		vim.cmd [[ do User LspAttachBuffers ]]
	end)

	-- global custom location-list diagnostics window toggle.
	local args = { noremap = true, silent = true }
	vim.api.nvim_set_keymap(
		'n',
		'<Leader>a',
		'<cmd>lua require("user").diagnostic.publish_loclist(true)<CR>',
		args
	)

	vim.api.nvim_exec([[
		augroup user_lspconfig
			autocmd!

			" See https://github.com/kosayoda/nvim-lightbulb
			autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
			" Automatic diagnostic hover
			" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({ focusable=false })
		augroup END
	]], false)
end
