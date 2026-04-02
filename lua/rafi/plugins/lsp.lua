-- LSP: Extend LazyVim settings
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Quickstart configurations for the Nvim LSP client
	-- :h lspconfig.txt  :h lspconfig-all
	--
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/lsp/init.lua
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/lsp/keymaps.lua
	{
		'nvim-lspconfig',
		opts = {
			inlay_hints = {
				enabled = false,
			},
			opts = {
				servers = {
					['*'] = {
						-- stylua: ignore
						keys = {
							{ '<leader>cl', false },
							{ '<c-k>', false, mode = 'i' },
							{ '<leader>cli', vim.lsp.buf.incoming_calls, desc = 'Incoming calls' },
							{ '<leader>clo', vim.lsp.buf.outgoing_calls, desc = 'Outgoing calls' },
							{ '<leader>ciwa', vim.lsp.buf.add_workspace_folder, desc = 'Add Workspace Folders' },
							{ '<leader>ciwr', vim.lsp.buf.remove_workspace_folder, desc = 'Remove Workspace Folder' },
							{ '<leader>ciwl', '<cmd>lua =vim.lsp.buf.list_workspace_folders()<CR>', desc = 'List Workspace Folders' },
						},
					},
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Portable package manager for Neovim
	-- :h mason.nvim
	--
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/lsp/init.lua
	{
		'mason.nvim',
		opts = {
			ui = {
				border = 'rounded',
				width = 0.7,
				height = 0.85,
				icons = {
					package_pending = '󰔟',
				},
			},
		},
	},
}
