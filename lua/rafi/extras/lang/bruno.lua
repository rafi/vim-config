-- Bruno: .bru filetype and its tree-sitter parser

vim.filetype.add({ extension = { bru = 'bruno' } })

-- Built with the repo's queries by arborist (first bruno buffer) or
-- nvim-treesitter (installed on load).
require('rafi.util.lang').add({
	parsers = {
		bruno = { url = 'https://github.com/Scalamando/tree-sitter-bruno' },
	},
})
