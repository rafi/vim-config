-- plugin: nvim-treesitter
-- see: https://github.com/nvim-treesitter/nvim-treesitter
-- rafi settings

-- Setup extra parsers.
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.http = {
	install_info = {
		url = 'https://github.com/NTBBloodbath/tree-sitter-http',
		files = { 'src/parser.c' },
		branch = 'main',
	},
	filetype = 'http',
}

-- Setup treesitter
require('nvim-treesitter.configs').setup({
	-- all, maintained, or list of languages
	ensure_installed = {
		'bash', 'c', 'clojure', 'cmake', 'comment', 'commonlisp',
		'cpp', 'css', 'dart', 'dockerfile', 'dot', 'fennel', 'fish',
		'go', 'gomod', 'gowork', 'graphql', 'hack', 'haskell', 'hcl',
		'help', 'html', 'http', 'java', 'javascript', 'jsdoc', 'json',
		'json5', 'jsonc', 'julia', 'kotlin', 'latex', 'llvm', 'lua',
		'make', 'markdown', 'ninja', 'nix', 'norg', 'perl', 'php',
		'pug', 'python', 'query', 'r', 'regex', 'rst', 'ruby', 'rust',
		'scala', 'scheme', 'scss', 'svelte', 'todotxt', 'toml', 'tsx',
		'typescript', 'vala', 'vim', 'vue', 'yaml', 'zig',
	},

	highlight = {
		enable = true,
		disable = { 'vim' },
	},

	additional_vim_regex_highlighting = false,

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
		-- Let other plugins (kommentary) call 'update_commentstring()' manually.
		enable_autocmd = false,
	},

	-- See: https://github.com/windwp/nvim-ts-autotag
	autotag = {
		enable = true,
		filetypes = {
			'html',
			'javascript',
			'javascriptreact',
			'typescriptreact',
			'svelte',
			'vue',
		}
	}

})
