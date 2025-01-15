-- LSP: Extend LazyVim settings
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Quickstart configurations for the Nvim LSP client
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/lsp/init.lua
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/lsp/keymaps.lua
	{
		'neovim/nvim-lspconfig',
		-- stylua: ignore
		opts = function()
			local keys = require('lazyvim.plugins.lsp.keymaps').get()
			keys[#keys + 1] = { '<c-k>', false, mode = 'i' }
			keys[#keys + 1] = { '<Leader>csi', vim.lsp.buf.incoming_calls, desc = 'Incoming calls' }
			keys[#keys + 1] = { '<Leader>cso', vim.lsp.buf.outgoing_calls, desc = 'Outgoing calls' }
			keys[#keys + 1] = { '<Leader>fwa', vim.lsp.buf.add_workspace_folder, desc = 'Show Workspace Folders' }
			keys[#keys + 1] = { '<Leader>fwr', vim.lsp.buf.remove_workspace_folder, desc = 'Remove Workspace Folder' }
			keys[#keys + 1] = { '<Leader>fwl', '<cmd>lua =vim.lsp.buf.list_workspace_folders()<CR>', desc = 'List Workspace Folders' }
		end,
	},

	-----------------------------------------------------------------------------
	-- Portable package manager for Neovim
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/lsp/init.lua
	{
		'mason.nvim',
		keys = {
			{ '<leader>cm', false },
			{ '<leader>mm', '<cmd>Mason<cr>', desc = 'Mason' },
		},
		opts = {
			ui = {
				border = 'rounded',
			},
		},
	},
}
