-- plugin: kommentary
-- see: https://github.com/b3nj5m1n/kommentary
-- rafi settings

-- Setup context-aware commenting via nvim-ts-context-commentstring
local update_commentstring = {
	hook_function = function()
		-- See https://github.com/JoosepAlviste/nvim-ts-context-commentstring
		require('ts_context_commentstring.internal').update_commentstring()
	end,
	single_line_comment_string = 'auto',
	multi_line_comment_strings = 'auto',
}

local k = require('kommentary.config')
k.configure_language('typescriptreact', update_commentstring)
k.configure_language('javascriptreact', update_commentstring)
k.configure_language('html', update_commentstring)
k.configure_language('svelte', update_commentstring)
k.configure_language('markdown', update_commentstring)

k.configure_language('lua', {
	single_line_comment_string = '--',
	multi_line_comment_strings = {'--[[', ']]'},
	prefer_single_line_comments = true,
})

-- Mappings
vim.api.nvim_set_keymap('n', '<Leader>v', '<Plug>kommentary_line_default', {})
vim.api.nvim_set_keymap('x', '<Leader>v', '<Plug>kommentary_visual_default<C-c>', {})
