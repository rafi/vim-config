-- plugin: kommentary
-- see: https://github.com/b3nj5m1n/kommentary
-- rafi settings

-- Setup context-aware commenting via nvim-ts-context-commentstring
local kommentaryHook = {
	hook_function = function()
		-- See https://github.com/JoosepAlviste/nvim-ts-context-commentstring
		require('ts_context_commentstring.internal').update_commentstring()
	end,
	single_line_comment_string = 'auto',
	multi_line_comment_strings = 'auto'
}

local kommentaryCfg = require('kommentary.config')
kommentaryCfg.configure_language('typescriptreact', kommentaryHook)
kommentaryCfg.configure_language('javascriptreact', kommentaryHook)
kommentaryCfg.configure_language('html', kommentaryHook)
kommentaryCfg.configure_language('svelte', kommentaryHook)
kommentaryCfg.configure_language('markdown', kommentaryHook)

-- Mappings
vim.api.nvim_set_keymap('n', '<Leader>v', '<Plug>kommentary_line_default', {})
vim.api.nvim_set_keymap('x', '<Leader>v', '<Plug>kommentary_visual_default<C-c>', {})
