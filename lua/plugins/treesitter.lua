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
	-- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	textobjects = {
		select = {
			enable = true,
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
	},
	-- See: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
	context_commentstring = {
		enable = true,
		-- The plugin caw.vim will automatically detect and use this plugin itself
		enable_autocmd = false,
	},
})
