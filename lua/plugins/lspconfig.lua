-- plugin: nvim-lspconfig
-- see: https://github.com/neovim/nvim-lspconfig
--      https://github.com/williamboman/nvim-lsp-installer
--      https://github.com/ray-x/lsp_signature.nvim
--      https://github.com/kosayoda/nvim-lightbulb
-- rafi settings

-- Buffer attached
local on_attach = function(client, bufnr)
	local function map_buf(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	-- Keyboard mappings
	local opts = { noremap = true, silent = true }
	map_buf('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

	-- Short-circuit for Helm template files
	if vim.bo[bufnr].buftype ~= '' or vim.bo[bufnr].filetype == 'helm' then
		require('user').diagnostic.disable(bufnr)
		return
	end

	map_buf('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	map_buf('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	map_buf('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	map_buf('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	map_buf('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	map_buf('n', ',s', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	map_buf('n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	map_buf('n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	map_buf('n', ',wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	map_buf('n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	map_buf('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	map_buf('n', '<Leader>ce', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

	-- Set some keybinds conditional on server capabilities
	if client.supports_method('textDocument/formatting') then
		if vim.fn.has('nvim-0.8') == 1 then
			map_buf('n', ',f', '<cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>', opts)
		else
			map_buf('n', ',f', '<cmd>lua vim.lsp.buf.formatting(nil, 2000)<CR>', opts)
		end
	end
	if client.supports_method('textDocument/rangeFormatting') then
		map_buf('x', ',f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
	end

	-- lspsaga.nvim
	-- See https://github.com/glepnir/lspsaga.nvim
	-- buf_set_keymap('n', '<Leader>f', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
	-- buf_set_keymap('n', 'K', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
	-- buf_set_keymap('n', ',s', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)
	-- buf_set_keymap('n', ',rn', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
	-- buf_set_keymap('n', '<Leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)
	-- buf_set_keymap('v', '<Leader>ca', ':<C-u>lua require("lspsaga.codeaction").range_code_action()<CR>', opts)

	-- lsp_signature.nvim
	-- See https://github.com/ray-x/lsp_signature.nvim
	-- require('lsp_signature').on_attach({
	-- 	bind = true,
	-- 	check_pumvisible = true,
	-- 	hint_enable = false,
	-- 	hint_prefix = ' ',  --  
	-- 	handler_opts = { border = 'rounded' },
	-- 	zindex = 50,
	-- }, bufnr)

	if client.config.flags then
		client.config.flags.allow_incremental_sync = true
		-- client.config.flags.debounce_text_changes  = vim.opt.updatetime:get()
	end

	-- Set autocommands conditional on server capabilities
	if client.supports_method('textDocument/documentHighlight') then
		vim.api.nvim_exec([[
			augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]], false)
	end
end

-- Combine base config for each server and merge user-defined settings.
local function make_config(server_name)
	-- Setup base config for each server.
	local c = {}
	c.on_attach = on_attach
	local cap = vim.lsp.protocol.make_client_capabilities()
	c.capabilities = require('cmp_nvim_lsp').update_capabilities(cap)

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

-- main

local function setup()
	-- Config
	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})

	-- Diagnostics signs and highlights
	--   Error:   ✘
	--   Warn:  ⚠  
	--   Hint:  
	--   Info:   ⁱ
	local signs = { Error = '✘', Warn = '', Hint = '', Info = 'ⁱ'}
	for type, icon in pairs(signs) do
		local hl = 'DiagnosticSign' .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
	end

	-- Setup CompletionItemKind symbols, see lua/lsp_kind.lua
	-- require('lsp_kind').init()

	-- Configure LSP Handlers
	-- ---

	vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics, {
			virtual_text = {
				-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-source-in-diagnostics-neovim-06-only
				source = 'if_many',
				prefix = '●',
			},
		})

	-- Configure diagnostics publish settings
	-- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
	-- 	vim.lsp.diagnostic.on_publish_diagnostics, {
	-- 		signs = true,
	-- 		underline = true,
	-- 		update_in_insert = false,
	-- 		severity_sort = true,
	-- 		virtual_text = {
	-- 			spacing = 4,
	-- 			-- prefix = '',
	-- 		}
	-- 	}
	-- )

	-- Configure help hover (normal K) handler
	vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
		vim.lsp.handlers.hover, { border = 'rounded' }
	)

	-- Configure signature help (,s) handler
	vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
		vim.lsp.handlers.signature_help, { border = 'rounded' }
	)

	-- Setup language servers using nvim-lsp-installer
	-- See https://github.com/williamboman/nvim-lsp-installer
	local lsp_installer = require('nvim-lsp-installer')
	lsp_installer.setup()

	-- Setup language servers using nvim-lspconfig
	local lspconfig = require('lspconfig')
	for _, ls in pairs(lsp_installer.get_installed_servers()) do
		local opts = make_config(ls.name)
		lspconfig[ls.name].setup(opts)
	end

	-- global custom location-list diagnostics window toggle.
	local args = { noremap = true, silent = true }
	local function nmap(lhs, rhs) vim.api.nvim_set_keymap('n', lhs, rhs, args) end
	nmap('<Leader>a', '<cmd>lua require("user").diagnostic.publish_loclist(true)<CR>')
	nmap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
	nmap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')

	require('nvim-lightbulb').setup({ ignore = {'null-ls'} })

	vim.api.nvim_exec([[
		augroup user_lspconfig
			autocmd!

			" See https://github.com/kosayoda/nvim-lightbulb
			autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
			" Automatic diagnostic hover
			" autocmd CursorHold * lua require("user").diagnostic.open_float({ focusable=false })
		augroup END
	]], false)
end

return {
	setup = setup,
	on_attach = on_attach,
}
-- vim: set ts=2 sw=2 tw=80 noet :
