-- plugin: nvim-treesitter-textobjects
-- see: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
-- rafi settings

require'nvim-treesitter.configs'.setup {
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
}
