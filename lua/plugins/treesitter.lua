-- plugin: nvim-treesitter
-- see: https://github.com/nvim-treesitter/nvim-treesitter
-- rafi settings

require'nvim-treesitter.configs'.setup {
	ensure_installed = 'maintained', -- all, maintained, or list of languages
	highlight = {
		enable = true,
		use_languagetree = false, -- Very unstable
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = 'gnn',
			node_incremental = 'grn',
			scope_incremental = 'grc',
			node_decremental = 'grm',
		},
	},
	indent = {
		enable = true
	},
	refactor = {
		highlight_definitions = { enable = true },
		highlight_current_scope = { enable = true },
	},
}
