-- plugin: bqf
-- see: https://github.com/kevinhwang91/nvim-bqf
-- rafi settings

-- :h bqf.txt
require('bqf').setup({
	auto_resize_height = false,
	func_map = {
		tab = 'st',
		split = 'sv',
		vsplit = 'sg',

		stoggleup = 'K',
		stoggledown = 'J',
		stogglevm = '<Space>',

		ptoggleitem = 'p',
		ptoggleauto = 'P',
		ptogglemode = 'zp',

		pscrollup = '<C-b>',
		pscrolldown = '<C-f>',

		prevfile = 'gk',
		nextfile = 'gj',

		prevhist = '<S-Tab>',
		nexthist = '<Tab>',
	},
	preview = {
		auto_preview = true,
		should_preview_cb = function(bufnr)
			-- file size greater than 100kb can't be previewed automatically
			local filename = vim.api.nvim_buf_get_name(bufnr)
			local fsize = vim.fn.getfsize(filename)
			if fsize > 100 * 1024 then
				return false
			end
			return true
		end,
	},
})
