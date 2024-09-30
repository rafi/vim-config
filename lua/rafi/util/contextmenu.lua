-- Context-aware menu
-- https://github.com/rafi/vim-config

---@class rafi.util.contextmenu
local M = {}

---@param method string
---@param clients vim.lsp.Client[]
---@return boolean
local function supports_method(method, clients)
	for _, client in pairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

M.show = function()
	if vim.fn.has('nvim-0.9') ~= 1 then
		vim.notify(
			'You must be running Neovim ≥9.0',
			vim.log.levels.WARN,
			{ title = 'Contextmenu' }
		)
		return
	end

	local cword = vim.fn.expand('<cword>')
	local bufnr = vim.api.nvim_get_current_buf()
	local clients
	if vim.lsp.get_clients ~= nil then
		clients = vim.lsp.get_clients({ bufnr = bufnr })
	else
		---@diagnostic disable-next-line: deprecated
		clients = vim.lsp.get_active_clients({ bufnr = bufnr })
	end

	-- Remove all menu options
	pcall(vim.cmd.aunmenu, 'PopUp')

	if cword == '' then
		-- Cursor is on blank character.
		vim.cmd([[
			nmenu     PopUp.Select\ All  ggVG
			nnoremenu PopUp.-1-          <Nop>
		]])
	else
		-- Add LSP methods, only if one of the servers support it.
		if supports_method('textDocument/definition', clients) then
			vim.cmd(
				'nnoremenu PopUp.Go\\ to\\ &definition <cmd>lua vim.lsp.buf.definition()<CR>'
			)
		end

		if supports_method('textDocument/references', clients) then
			vim.cmd(
				'nnoremenu PopUp.Go\\ to\\ &references… <cmd>lua vim.lsp.buf.references()<CR>'
			)
		end
		if supports_method('textDocument/implementation', clients) then
			vim.cmd(
				'nnoremenu PopUp.Implementation <cmd>lua vim.lsp.buf.implementation()<CR>'
			)
		end

		if #clients > 0 then
			vim.cmd([[
				nnoremenu PopUp.-1-            <Nop>
				nmenu PopUp.Find\ symbol…  <cmd>lua require'telescope.builtin'.lsp_workspace_symbols({default_text = vim.fn.expand('<cword>')})<CR>
			]])
		end

		vim.cmd([[
			nmenu PopUp.Grep… <cmd>lua require'telescope.builtin'.live_grep({default_text = vim.fn.expand('<cword>')})<CR>
			nmenu PopUp.-2-   <Nop>
		]])
	end

	vim.cmd([[
		nmenu PopUp.Diagnostics        <cmd>Trouble<CR>
		nmenu PopUp.Bookmark           m;
		nmenu PopUp.TODOs              <cmd>TodoTrouble<CR>
		nmenu PopUp.Git\ diff          <cmd>Gdiffsplit<CR>
		nmenu PopUp.Unsaved\ diff      <cmd>DiffOrig<CR>
		nmenu PopUp.Open\ in\ browser  <cmd>lua require('gitlinker').get_buf_range_url('n')<CR>
	]])

	pcall(vim.cmd.popup, 'PopUp')
end

return M
