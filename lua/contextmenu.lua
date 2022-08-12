-- rafi context-menu
-- https://github.com/rafi/vim-config

local M = {}

local function exec(input)
	vim.api.nvim_exec(input, true)
end

local function supports_method(method, clients)
	for _, client in pairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

M.show = function()
	if vim.fn.has('nvim-0.8') ~= 1 then
		print('You must be running Neovim ≥8.0')
		return
	end

	local cword = vim.fn.expand('<cword>')
	local clients = vim.lsp.get_active_clients()

	pcall(function() exec('aunmenu Context') end)

	if cword == '' then
		-- Cursor is on blank character.
		exec('nmenu Context.Select\\ All  ggVG')
		exec('nmenu Context.-1-           <Nop>')

	else
		-- Add LSP methods, only if one of the servers support it.
		if supports_method('textDocument/declaration', clients) then
			exec('nmenu Context.Declaration  <cmd>lua vim.lsp.buf.declaration()<CR>')
		end
		if supports_method('textDocument/definition', clients) then
			exec('nmenu Context.&Definition  <cmd>lua vim.lsp.buf.definition()<CR>')
		end

		if supports_method('textDocument/references', clients) then
			exec('nmenu Context.&References…  <cmd>lua vim.lsp.buf.references()<CR>')
		end
		if supports_method('textDocument/implementation', clients) then
			exec('nmenu Context.Implementation  <cmd>lua vim.lsp.buf.implementation()<CR>')
		end
		exec('nmenu Context.-1-            <Nop>')

		exec('nmenu Context.Find\\ symbol… <cmd>lua require("plugins.telescope").pickers.lsp_workspace_symbols_cursor()<CR>')
		exec('nmenu Context.Grep…          <cmd>lua require("plugins.telescope").pickers.grep_string_cursor()<CR>')
		exec('nmenu Context.Jump…          <cmd>AnyJump<CR>')
		exec('nmenu Context.-2-            <Nop>')
	end

	exec('nmenu Context.Diagnostics         <cmd>Trouble<CR>')
	exec('nmenu Context.Bookmark            m;')
	exec('nmenu Context.TODO                <cmd>TodoTrouble<CR>')
	exec('nmenu Context.Git\\ diff          <cmd>Gina compare<CR>')
	exec('nmenu Context.Unsaved\\ diff      <cmd>DiffOrig<CR>')
	exec('nmenu Context.Open\\ in\\ browser <cmd>Gina browse<CR>')

	exec('popup Context')
end

return M
