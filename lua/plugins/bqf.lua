-- plugin: bqf
-- see: https://github.com/kevinhwang91/nvim-bqf/
-- rafi settings

require('bqf').setup({
	auto_resize_height = false,
	preview = { auto_preview = false },
	func_map = {
		tab = 'st',
		split = 'sv',
		vsplit = 'sg',
		ptoggleitem = 'p',
	},
})
