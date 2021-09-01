-- plugin: nvim-treesitter
-- see: https://github.com/nvim-treesitter/nvim-treesitter
-- rafi settings

local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
parser_configs.http = {
	install_info = {
		url = 'https://github.com/NTBBloodbath/tree-sitter-http',
		files = { 'src/parser.c' },
		branch = 'main',
	},
}

require('nvim-treesitter.configs').setup({
	ensure_installed = 'maintained', -- all, maintained, or list of languages
	highlight = {
		enable = true,
	},
	-- incremental_selection = {
	-- 	enable = true,
	-- 	keymaps = {
	-- 		init_selection = 'gnn',
	-- 		node_incremental = 'grn',
	-- 		scope_incremental = 'grc',
	-- 		node_decremental = 'grm',
	-- 	},
	-- },
	indent = {
		enable = true,
	},
	refactor = {
		highlight_definitions = { enable = true },
		highlight_current_scope = { enable = true },
	},
})
